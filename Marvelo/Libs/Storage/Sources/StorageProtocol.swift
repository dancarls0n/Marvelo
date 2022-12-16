//
//  StorageProtocol.swift
//
//
//  Created by Jeff Pedersen on 2022-12-16.
//

import Foundation
import Models

public enum StorageKey : String {
    case characters
    case events
    case favorites
}

public protocol StorageProtocol {
    func save(_ value: Codable, for key: StorageKey)
    func fetchCharacters() -> [Character]?
    func fetchFavorites() -> FavoriteList?
    func fetchEvents() -> [Event]?
}
