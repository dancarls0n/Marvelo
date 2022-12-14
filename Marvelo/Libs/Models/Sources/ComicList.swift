//
//  ComicList.swift
//  marvelapp
//
//  Created by Felipe Antonio Cardoso on 06/04/19.
//  Copyright © 2019 Felipe Antonio Cardoso. All rights reserved.
//

import Foundation

public struct ComicList {
    
    public let available: Int?
    public let returned: Int?
    public let collectionURI: String?
    public let items: [ComicSummary]?
    
    enum CodingKeys: String, CodingKey {
        case available
        case returned
        case collectionURI
        case items
    }
}

extension ComicList: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = try container.decodeIfPresent(Int.self, forKey: .available)
        self.returned = try container.decodeIfPresent(Int.self, forKey: .returned)
        self.collectionURI = try container.decodeIfPresent(String.self, forKey: .collectionURI)
        self.items = try container.decodeIfPresent([ComicSummary].self, forKey: .items)
    }
}

extension ComicList: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(collectionURI, forKey: .collectionURI)
        try container.encodeIfPresent(returned, forKey: .returned)
        try container.encodeIfPresent(items, forKey: .items)
    }
}
