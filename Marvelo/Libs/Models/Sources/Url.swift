

import Foundation
public struct Url : Codable {
	let type : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case url = "url"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
