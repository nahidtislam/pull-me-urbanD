//
//  ControlViewModel.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import SwiftUI

@MainActor class ControlViewModel: ObservableObject {
    @Published var randomWords = [UDWord]()
    @Published var addedWords = [UDWord]()
    
    @Published var errorHappened = false
    
    
    @Published var wordsToPick: [UDWord] = []
    @Published var poppedWord: UDWord?
    @Published var scrollToID: Int?
    
    let censored = true
    let censoredWords: Set = ["this is a bad word", "very bad bad word", "nil", "null"]
    
    
    var words: [UDWord] { addedWords + randomWords }
    
    func load(word: String, getAll: Bool = true) async {
        let url = UrbanDictAPI.selected(word: word).url
//        guard let downloaded = await downloadWords(from: url) else {
//            print("oh no")
//            return
//        }
        guard let downloaded = try? await UrbanDictAPI.selected(word: word).retrieve() else {
            print("oh no")
            return
        }
        handleLoaded(words: downloaded.list, forceSingle: !getAll)
    }
    
//    private func download(word: String) async -> [UDWord]? {
//        let url = UrbanDictAPI.selected(word: word).url
//
//        return await downloadWords(from: url)
//    }
//
//    private func downloadWords(from path: URL) async -> [UDWord]? {
//        do {
//            let data = try await URLSession.shared.data(from: path).0
//            let foundWords = try JSONDecoder().decode(ResponseFromUD.self, from: data).list
//
//            return foundWords.count > 0 ? foundWords : nil
//        }
//        catch {
//            return nil
//        }
//    }
        
    func pop(url: URL) -> OpenURLAction.Result {
        Task(priority: .userInitiated) {
            poppedWord = try? await UrbanDictAPI.retrieve(using: url).list.first
        }
        
        return poppedWord == nil ? .discarded : .handled
    }
    
    private func handleLoaded(words: [UDWord], forceSingle: Bool = false) {
        let word = words.first!
//        var words = words.filter({ $0.word.lowercased() == word.word.lowercased() })
        if words.count > 1 && !forceSingle { wordsToPick = words; return }
        
        if let matching = words.first(where: { $0.defid == word.defid }) {
            scrollToID = matching.defid
        } else {
            addedWords.insert(word, at: 0)
        }
    }
    
    func loadRandomWords() async {
        let url = UrbanDictAPI.random.url
        
        do {
            
            randomWords = try await UrbanDictAPI.random.retrieve().list
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
