//
//  ControlViewModel.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import SwiftUI

class ControlViewModel: ObservableObject {
    
    // seperated so the user can tell which words they added
    var randomWords = [UDWord]()
    var addedWords = [UDWord]()
    
    @Published var errorDescription: String?
    
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
        
        if word == ":word of the day:" {
            let apiCall = UrbanDictAPI.wordsOfTheDay
            guard let downloaded = try? await apiCall.retrieve().list else {
                print("no word")
                return
            }
            await handleLoaded(words: downloaded, forceSingle: !getAll)
            return
        }
        
        guard let downloaded = try? await apiCall.retrieve() else {
            print("oh no")
            return
        }
        
        // goes on the main acting thread as data is alreasy loaded
        await handleLoaded(words: downloaded.list, forceSingle: !getAll)
    }
    
    func load(id: Int) async {
        let apiCall = UrbanDictAPI.unique(id: id)
        guard let loaded = try? await apiCall.retrieve().list else {
            print("oh no")
            return
        }
        await handleLoaded(words: loaded, forceSingle: true)
    }
    
    func pop(url: URL) -> OpenURLAction.Result {
        DispatchQueue.main.async { [weak self] in
            Task(priority: .userInitiated) {
                self?.poppedWord = try? await UrbanDictAPI.retrieve(using: url).list.first
            }
        }
        
        return .handled
    }
    
    @MainActor
    private func handleLoaded(words: [UDWord], forceSingle: Bool = false) {
        let word = words.first!
        
        if words.count > 1 && !forceSingle { wordsToPick = words; return }
        
        let matching = words.first(where: { $0.defid == word.defid })
        insertSelected(newWord: matching)
    }
    
    @MainActor
    func loadRandomWords() async {
        do {
            randomWords = try await UrbanDictAPI.random.retrieve().list
            errorDescription = nil
        }
        catch {
            errorDescription = error.localizedDescription
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
