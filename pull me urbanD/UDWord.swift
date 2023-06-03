//
//  UDWord.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 18/03/2023.
//

import Foundation

struct UDWord: Codable, Identifiable, Equatable {
    let defid: Int
    
    let word: String
    let definition: String
    
    let example: String
    
    let thumbsUp: Int
    let thumbsDown: Int
    let currentVote: String // why's this a string
    
    let writtenOn: String
    
    let author: String
    
    let permalink: String
    
    
    var id: Int { defid }
    
    var writtenOnDate: Date {
        .init(writtenOn, withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
    }
    
    var overallVotes: Int {
        thumbsUp - thumbsDown
    }
}

struct ResponseFromUD: Decodable {
    let list: [UDWord]
}
