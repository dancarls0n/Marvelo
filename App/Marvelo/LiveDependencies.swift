//
//  LiveDependencies.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import DataStoreLive
import Foundation
import StorageLive

public class LiveDependencies {

    public static let shared = LiveDependencies()

    public private(set) var dataStore: DataStore

    private init() {
        let storage: Storage = StorageLive()
        self.dataStore = DataStoreLive(dependencies: DataStoreLive.Dependencies(storage: storage))
    }
}
