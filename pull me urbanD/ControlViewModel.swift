//
//  ControlViewModel.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import SwiftUI

@MainActor class ControlViewModel: ObservableObject {
    @Published var words = [UDWord]()
    @Published var errorHappened = false
    
    @Published var scrollToID: Int?
    
    
    func load(word: String) async {
        let url = UrbanDictAPI.selected(word: word).url
        
        do {
            let data = try await URLSession.shared.data(from: url).0
            guard let decoded = try? JSONDecoder().decode(ResponseFromUD.self, from: data),
                    let word = decoded.list.first else {
                return
            }
            
            if let matching = words.first(where: { $0.defid == word.defid }) {
                scrollToID = matching.defid
            } else {
                words.insert(word, at: 0)
            }
        }
        catch {}
            
    }
    
    func loadRandomWords() async {
        let url = UrbanDictAPI.random.url
        
        do {
            let data = try await URLSession.shared.data(from: url).0
            guard let decoded = try? JSONDecoder().decode(ResponseFromUD.self, from: data) else {
                errorHappened = true
                return
            }
            
            randomWords = decoded.list
            errorHappened = false
        }
        catch {
            errorHappened = true
        }
    }
    
    func insertSelected(newWord: UDWord?) {
        guard let newWord else { return }
        wordsToPick.removeAll()
        if let existingID = words.first(where: { $0 == newWord })?.defid {
            scrollToID = existingID
        } else {
            addedWords.insert(newWord, at: 0)
        }
    }
}
