//
//  UrbanDictAPI.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import Foundation

enum UrbanDictAPI {
    /*
     see link to spec at:
     https://github.com/urbandictionary-api/spec/blob/main/urbandictionary-api.yaml
     */
    
    case random
    case selected(word: String)
    case unique(id: Int)
    case wordsOfTheDay
    
    public var url: URL {
        var c = URLComponents()
        c.scheme = "https"
        c.host = "api.urbandictionary.com"
        c.path = preSlug
        c.queryItem = query
        
        return c.url!
    }
    
    private var preSlug: String {
        switch self {
        case .random:
            return "/v0/random"
        case .selected, .unique:
            return "/v0/define"
        case .wordsOfTheDay:
            return "/v0/words_of_the_day"
        }
    }
    
    private var query: URLQueryItem? {
        switch self {
        case .random, .wordsOfTheDay:
            return nil
        case .selected(let word):
            return .init(name: "term", value: word)
        case .unique(let id):
            return .init(name: "defid", value: String(id))
        }
    }
    
    public func retrieve() async throws -> ResponseFromUD {
        try await UrbanDictAPI.retrieve(using: url)
    }
    
    static func retrieve(using url: URL) async throws -> ResponseFromUD {
        let data = try await URLSession.shared.data(from: url).0
        let decoder: JSONDecoder = {
            let jd = JSONDecoder()
            jd.keyDecodingStrategy = .convertFromSnakeCase
            return jd
        }()
        
        return try decoder.decode(ResponseFromUD.self, from: data)
    }
}

extension URLComponents {
    var queryItem: URLQueryItem? {
        get {
            guard queryItems?.count == 1 else { return nil }
            return queryItems!.first!
        }
        set {
            guard let newValue else { queryItems = nil; return }
            queryItems = [newValue]
        }
    }
}
