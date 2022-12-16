//
//  StorageMock.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public struct StorageMock {

    public var saveClosure: (_ value: Codable, _ key: StorageKey) -> Void = { _, _ in }
    public var fetchCharactersClosure: () -> [Models.Character]? = { nil }
    public var fetchFavoritesClosure: () -> Models.FavoriteList? = { nil }
    public var fetchEventsClosure: () -> [Models.Event]? = { nil }
}

extension StorageMock: Storage {

    public func save(_ value: Codable, for key: StorageKey) {
        saveClosure(value, key)
    }

    public func fetchCharacters() -> [Models.Character]? {
        return fetchCharactersClosure()
    }

    public func fetchFavorites() -> Models.FavoriteList? {
        return fetchFavoritesClosure()
    }

    public func fetchEvents() -> [Models.Event]? {
        return fetchEventsClosure()
    }
}
