//
//  UrbanDictAPI.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import Foundation

enum UrbanDictAPI {
    case random
    case selected(word: String)
    
    var url: URL {
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
        case .selected:
            return "/v0/define"
        }
    }
    
    private var query: URLQueryItem? {
        switch self {
        case .random:
            return nil
        case .selected(let word):
            return .init(name: "term", value: word)
        }
    }
    
    func retrieve() async throws -> ResponseFromUD {
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
