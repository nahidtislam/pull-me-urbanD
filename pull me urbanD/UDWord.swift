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
    
    let thumbs_up: Int
    let thumbs_down: Int
    let current_vote: String // whyt's this a string
    
    let written_on: String
    
    let author: String
    
    let permalink: String
    
    
    var id: Int { defid }
    
    var written_on_date: Date {
        .init(written_on, withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
    }
    
    var overallVotes: Int {
        thumbs_up - thumbs_down
    }
}

struct ResponseFromUD: Decodable {
    let list: [UDWord]
}
