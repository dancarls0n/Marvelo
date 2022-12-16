//
//  APIClient.swift
//  
//
//  Created by Dan Carlson on 2022-12-14.
//

import CryptoKit
import Foundation
import Models
import Secrets

public struct APIClient {
	
	private struct Constants {
		static let baseUrl = URL(string: "https://gateway.marvel.com:443")!
	}
	
	public enum APIError: Error {
		case invalidUrl
	}
	
	public static func fetchEvents() async throws -> [Event] {
		
		var components = URLComponents(url: Constants.baseUrl.appendingPathComponent("v1/public/events"), resolvingAgainstBaseURL: true)
		
		let timestamp = "\(Date().timeIntervalSince1970)"
		let hash = MD5("\(timestamp)\(Secrets.marvelAPIKeyPrivate)\(Secrets.marvelAPIKeyPublic)")
		
		components?.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "hash", value: hash),
			URLQueryItem(name: "apikey", value: Secrets.marvelAPIKeyPublic)
		]
		
		guard let url = components?.url else { throw APIError.invalidUrl }
		
		let (data, _) = try await URLSession.shared.data(from: url)
		let dataWrapper = try JSONDecoder().decode(EventDataWrapper.self, from: data)
		let events = dataWrapper.data?.results ?? []
		return events
	}
	
	public static func fetchCharacters() async throws -> [Character] {

		var components = URLComponents(url: Constants.baseUrl.appendingPathComponent("v1/public/characters"), resolvingAgainstBaseURL: true)
	
		let timestamp = "\(Date().timeIntervalSince1970)"
		let hash = MD5("\(timestamp)\(Secrets.marvelAPIKeyPrivate)\(Secrets.marvelAPIKeyPublic)")
		
		components?.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "hash", value: hash),
			URLQueryItem(name: "apikey", value: Secrets.marvelAPIKeyPublic)
		]
		
		guard let url = components?.url else { throw APIError.invalidUrl }

		let (data, _) = try await URLSession.shared.data(from: url)
		let dataWrapper = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
		let characters = dataWrapper.data?.results ?? []
		return characters
	}
																																									
	private static func MD5(_ string: String) -> String {
			let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
			return digest.map {
				String(format: "%02hhx", $0)
			}.joined()
		}
}
