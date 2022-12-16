//
//  LiveDependencies.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import DataStore
import Foundation
import Storage

public class LiveDependencies {

    public static let shared = LiveDependencies()

    public private(set) var dataStore: DataStoreProtocol

    private init() {
        let storage: StorageProtocol = Storage()
        self.dataStore = DataStore(dependencies: DataStore.Dependencies(storage: storage))
    }
}