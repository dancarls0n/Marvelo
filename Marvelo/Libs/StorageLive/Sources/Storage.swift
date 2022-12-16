//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-14.
//

import Foundation
import Models
@_exported import Storage

public struct Storage: StorageProtocol {

    public init() { }

    public func save(_ value: Codable, for key: StorageKey) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey:key.rawValue)
    }

    public func fetchCharacters() -> [Character]? {
        guard let data = UserDefaults.standard.value(forKey: StorageKey.characters.rawValue) as? Data else { return nil }
        return try? PropertyListDecoder().decode([Character].self, from: data)
    }

    public func fetchFavorites() -> FavoriteList? {
        guard let data = UserDefaults.standard.value(forKey: StorageKey.favorites.rawValue) as? Data else { return nil }
        return try? PropertyListDecoder().decode(FavoriteList.self, from: data)
    }

    public func fetchEvents() -> [Event]? {
        guard let data = UserDefaults.standard.value(forKey: StorageKey.favorites.rawValue) as? Data else { return nil }
        return try? PropertyListDecoder().decode([Event].self, from: data)
    }
}
