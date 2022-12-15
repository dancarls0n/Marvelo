

import Foundation
public struct Event {
	public let id : Int?
	public let title : String?
	public let description : String?
	public let resourceURI : String?
	public let urls : [Url]?
	public let modified : String?
	public let start : String?
	public let end : String?
	public let thumbnail : Image?
	public let characters : CharacterList?
	public let comics : ComicList?
	public let stories : StoryList?
	public let series : SeriesList?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case description = "description"
		case resourceURI = "resourceURI"
		case urls = "urls"
		case modified = "modified"
		case start = "start"
		case end = "end"
		case thumbnail = "thumbnail"
		case comics = "comics"
		case stories = "stories"
		case series = "series"
		case characters = "characters"
	}
}

extension Event : Equatable, Hashable {
	public static func == (lhs: Event, rhs: Event) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(title)
		hasher.combine(description)
		hasher.combine(start)
		hasher.combine(end)
		hasher.combine(thumbnail)
		hasher.combine(modified)
		hasher.combine(characters)
	}
}

extension Event: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(Int.self, forKey: .id)
		self.title = try container.decodeIfPresent(String.self, forKey: .title)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
		self.modified = try container.decodeIfPresent(String.self, forKey: .modified)
		self.urls = try container.decodeIfPresent([Url].self, forKey: .urls)
		self.start = try container.decodeIfPresent(String.self, forKey: .start)
		self.end = try container.decodeIfPresent(String.self, forKey: .end)
		self.thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
		self.comics = try container.decodeIfPresent(ComicList.self, forKey: .comics)
		self.series = try container.decodeIfPresent(SeriesList.self, forKey: .series)
		self.stories = try container.decodeIfPresent(StoryList.self, forKey: .stories)
		self.characters = try container.decodeIfPresent(CharacterList.self, forKey: .characters)
	}
}

extension Event: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(title, forKey: .title)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
		try container.encodeIfPresent(comics, forKey: .comics)
		try container.encodeIfPresent(series, forKey: .series)
		try container.encodeIfPresent(stories, forKey: .stories)
		try container.encodeIfPresent(characters, forKey: .characters)
	}
}
