//
//  ControlViewModel.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import SwiftUI

class ControlViewModel: ObservableObject {
    @Published var randomWords = [UDWord]()
    @Published var addedWords = [UDWord]()
    
    @Published var errorHappened = false
    
    
    @Published var wordsToPick: [UDWord] = []
    @Published var poppedWord: UDWord?
    @Published var scrollToID: Int?
    
    var censored: Bool {
        let cal = Calendar.current
        let now = Date.now
        
        let day = cal.component(.day, from: now)
        let month = cal.component(.month, from: now)
        
        return day == 1 && month == 4 // april fools :)
    }
    let censoredWords: Set = ["this is a bad word", "very bad bad word", "nil", "null"]
    
    
    var words: [UDWord] { addedWords + randomWords }
    
    func load(word: String, getAll: Bool = true) async {
        let apiCall = UrbanDictAPI.selected(word: word)
        
        guard let downloaded = try? await apiCall.retrieve() else {
            print("oh no")
            return
        }
        handleLoaded(words: downloaded.list, forceSingle: !getAll)
    }
        
    func pop(url: URL) -> OpenURLAction.Result {
        DispatchQueue.main.async { [weak self] in
            Task(priority: .userInitiated) {
                self?.poppedWord = try? await UrbanDictAPI.retrieve(using: url).list.first
            }
        }
        
        return .handled
    }
    
    private func handleLoaded(words: [UDWord], forceSingle: Bool = false) {
        let word = words.first!
        
        if words.count > 1 && !forceSingle { wordsToPick = words; return }
        
        if let matching = words.first(where: { $0.defid == word.defid }) {
            scrollToID = matching.defid
        } else {
            addedWords.insert(word, at: 0)
        }
    }
    
    @MainActor
    func loadRandomWords() async {
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
