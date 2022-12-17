//
//  Character.swift
//  marvelapp
//
//  Created by Felipe Antonio Cardoso on 05/04/19.
//  Copyright © 2019 Felipe Antonio Cardoso. All rights reserved.
//

import Foundation

public struct Character {
    
    public let id: Int?
    public let name: String?
    public let description: String?
    public let thumbnail: Image?
    public let modified : String?
    public let comics: ComicList?
    public let series: SeriesList?
    public let stories: StoryList?
    public let events: EventList?
    
    public var avatarURL: URL? {
        guard let imagePath = thumbnail?.path else { return nil }
        let httpsUrl = imagePath.replacingOccurrences(of: "http", with: "https")
        let smallUrl = httpsUrl + "/portrait_small.jpg"
        return URL(string: smallUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case modified
        case comics
        case series
        case stories
        case events
    }
    
    public init(id: Int? = nil, name: String? = nil, description: String? = nil, thumbnail: Image? = nil, modified: String? = nil, comics: ComicList? = nil, series: SeriesList? = nil, stories: StoryList? = nil, events: EventList? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.modified = modified
        self.comics = comics
        self.series = series
        self.stories = stories
        self.events = events
    }
    
}

extension Character : Equatable, Hashable {
    public static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(thumbnail)
        hasher.combine(modified)
        hasher.combine(events)
    }
}

extension Character: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.modified = try container.decodeIfPresent(String.self, forKey: .modified)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
        self.comics = try container.decodeIfPresent(ComicList.self, forKey: .comics)
        self.series = try container.decodeIfPresent(SeriesList.self, forKey: .series)
        self.stories = try container.decodeIfPresent(StoryList.self, forKey: .stories)
        self.events = try container.decodeIfPresent(EventList.self, forKey: .events)
    }
}

extension Character: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(comics, forKey: .comics)
        try container.encodeIfPresent(series, forKey: .series)
        try container.encodeIfPresent(stories, forKey: .stories)
        try container.encodeIfPresent(events, forKey: .comics)
    }
}
