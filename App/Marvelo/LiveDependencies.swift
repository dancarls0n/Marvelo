//
//  LiveDependencies.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation

import DataStoreLive
import NotificationClientLive
import StorageLive

public class LiveDependencies {
  
  public static let shared = LiveDependencies()
  
  public private(set) var dataStore: DataStore
  public private(set) var notificationClient: NotificationClient
  
  private init() {
    let storage: Storage = StorageLive()
    self.notificationClient = NotificationClientLive()
    self.dataStore = DataStoreLive(dependencies: DataStoreLive.Dependencies(storage: storage))
  }
}
