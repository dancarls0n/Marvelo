//
//  File.swift
//  
//
//  Created by Dan Carlson on 2022-12-14.
//

import Foundation

import Models

public struct Storage {
	
	public enum Key : String {
		case characters
		case events
		case favorites
	}
	
	public static func save(_ value: Codable, for key: Storage.Key) {
		UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey:key.rawValue)
	}
	
	public static func fetchCharacters() -> [Character]? {
		guard let data = UserDefaults.standard.value(forKey:Storage.Key.characters.rawValue) as? Data else { return nil }
		return try? PropertyListDecoder().decode([Character].self, from: data)
	}
	
	public static func fetchFavorites() -> FavoriteList? {
		guard let data = UserDefaults.standard.value(forKey:Storage.Key.favorites.rawValue) as? Data else { return nil }
		return try? PropertyListDecoder().decode(FavoriteList.self, from: data)
	}
	
	public static func fetchEvents() -> [Event]? {
		guard let data = UserDefaults.standard.value(forKey:Storage.Key.favorites.rawValue) as? Data else { return nil }
		return try? PropertyListDecoder().decode([Event].self, from: data)
	}
}
