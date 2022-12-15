//
//  EventList.swift
//  marvelapp
//
//  Created by Felipe Antonio Cardoso on 07/04/19.
//  Copyright © 2019 Felipe Antonio Cardoso. All rights reserved.
//

import Foundation

public struct EventList {
    
    public let available: Int?
    public let returned: Int?
    public let collectionURI: String?
    public let items: [Event]?
    
    enum CodingKeys: String, CodingKey {
        case available
        case returned
        case collectionURI
        case items
    }
}

extension EventList : Equatable, Hashable {
	public static func == (lhs: EventList, rhs: EventList) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(available)
		hasher.combine(returned)
		hasher.combine(collectionURI)
		hasher.combine(items)
	}
}

extension EventList: Decodable {
	public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([Event].self, forKey: .items)
    }
}

extension EventList: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(returned, forKey: .returned)
        try container.encodeIfPresent(items, forKey: .items)
    }
}
