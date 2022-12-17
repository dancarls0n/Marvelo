  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation

@_exported import Ably

import Models
@_exported import NotificationClient
import Secrets

public class NotificationClientLive : NotificationClient {
    
    public init() { }
    
    private var newCharacterContinuations: [UUID: AsyncStream<Character>.Continuation] = [:]
    private var notificationEventContinuations: [UUID: AsyncStream<NotificationsEvent>.Continuation] = [:]
    
    var ablyClient: ARTRealtime?
    
    public func startListening() {
        
        guard ablyClient?.connection.state != .connected else { return }
        
        ablyClient = ARTRealtime(key: Secrets.ablyKey)
        ablyClient?.connection.on { [weak self] stateChange in
            guard let self = self else { return }
            switch stateChange.current {
                case .connected:
                    guard let channel = self.ablyClient?.channels.get("Marvelous") else {
                        self.publishNotificationEvent(.streamError("Channel Not Connected"))
                        return
                    }
                    channel.subscribe { [weak self] message in
                        self?.onChannelMessage(message)
                    }
                case .failed:
                    self.publishNotificationEvent(.connectionError(stateChange.reason?.message))
                default:
                    break
            }
        }
    }
    
    public func stopListening() {
        
        guard let client = ablyClient else {
            self.publishNotificationEvent(.connectionError("no client to stop"))
            return
        }
        
        _ = newCharacterContinuations.values.map { $0.finish() }
        _ = notificationEventContinuations.values.map { $0.finish() }
        
        client.close()
    }
    
    private func publishNotificationEvent( _ event: NotificationsEvent) {
        notificationEventContinuations.values.forEach { $0.yield(event) }
    }
    
    private func onChannelMessage(_ message: ARTMessage) {
        
        guard let messageData = message.data else {
            publishNotificationEvent(.messageError("No Data"))
            return
        }
        guard let messageDict = messageData as? NSDictionary,
              let characterDict = messageDict["results"] else {
            publishNotificationEvent(.messageError("Bad Data Format"))
            return
        }
        do {
            let decoder = JSONDecoder()
            let characterJsonData = try JSONSerialization.data(withJSONObject: characterDict, options: .prettyPrinted)
            let characterArray = try decoder.decode([Character].self, from: characterJsonData)
            guard let character = characterArray.first else {
                publishNotificationEvent(.messageError("No Character Sent"))
                return
            }
            
            newCharacterContinuations.values.forEach { $0.yield(character) }
            
        } catch {
            publishNotificationEvent(.messageError("Character Decode Failed: \(error.localizedDescription)"))
        }
    }
    
    public func newCharacterStream() -> AsyncStream<Models.Character> {
        let continuationID = UUID()
        return AsyncStream { continuation in
            newCharacterContinuations[continuationID] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.newCharacterContinuations[continuationID] = nil
            }
        }
    }
    
    public func notificationStream() -> AsyncStream<NotificationsEvent> {
        let continuationID = UUID()
        return AsyncStream { continuation in
            notificationEventContinuations[continuationID] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.notificationEventContinuations[continuationID] = nil
            }
        }  }
}
