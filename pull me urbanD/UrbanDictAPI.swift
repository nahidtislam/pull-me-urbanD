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
        c.path = slash
        c.queryItem = query
        
        return c.url!
    }
    
    var slash: String {
        switch self {
        case .random:
            return "/v0/random"
        case .selected:
            return "/v0/define"
        }
    }
    
    var query: URLQueryItem? {
        switch self {
        case .random:
            return nil
        case .selected(let word):
            return .init(name: "term", value: word)
        }
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
