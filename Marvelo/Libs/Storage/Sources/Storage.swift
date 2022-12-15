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
		UserDefaults.standard.set(value, forKey: key.rawValue)
	}
	
	public static func fetch(_ key: Storage.Key) -> Any? {
		 UserDefaults.standard.value(forKey: key.rawValue)
	}
}
