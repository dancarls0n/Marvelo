  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation

import Models

public enum NotificationsEvent: Equatable {
    case started
    case stopped
    case connectionError(String?)
    case streamError(String?)
    case messageError(String?)
    
    public var description: String {
        switch self {
            case .started:
                return "started"
            case .stopped:
                return "stopped"
            case .connectionError(let error):
                return "connectionError.\(error ?? "")"
            case .messageError(let error):
                return "messageError.\(error ?? "")"
            case .streamError(let error):
                return "streamError.\(error ?? "")"
        }
    }
}

public protocol NotificationClient {
    func startListening()
    func stopListening()
    func newCharacterStream() -> AsyncStream<Character>
    func notificationStream() -> AsyncStream<NotificationsEvent>
}
