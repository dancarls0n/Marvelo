//
//  Favorite.swift
//
//  Created by Dan Carlson on 2022-12-14.
//

import Foundation

public struct Favorite : Codable {
	public init(id: String = UUID().uuidString, characterID: Int) {
		self.id = id
		self.characterID = characterID
	}
	
	public var id: String = UUID().uuidString
	public var characterID: Int
}

public struct FavoriteList : Codable {
	public init() { }
	public var favorites:[Favorite] = []
}
