//
//  WordPicker.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 19/03/2023.
//

import SwiftUI

struct WordPicker: View {
    let wordsToPick: [UDWord]
    @Binding var selectedWord: UDWord?
    
    var sortedWords: [UDWord] {
        wordsToPick.sorted { lhs, rhs in
            lhs.overallVotes > rhs.overallVotes
        }
    }
    
    var body: some View {
        ScrollView {
            ForEach(sortedWords) { word in
                VStack(alignment: .leading, spacing: 20) {
                    Text(word.word)
                        .font(.largeTitle)
                    Text(word.definition.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""))
                        .font(.caption)
                    Label("votes: \(word.thumbs_up - word.thumbs_down)", systemImage: "arrow.\(word.thumbs_up >= word.thumbs_down ? "up" : "down").circle")
                        .foregroundColor(word.thumbs_up >= word.thumbs_down ? .teal : .red)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor))
                .onTapGesture {
                    selectedWord = word
                }
            }
        }
    }
}

struct WordPicker_Previews: PreviewProvider {
    static func egWords() -> [UDWord] {
        let url = Bundle.main.url(forResource: "wordpicker-list", withExtension: "json")!
        guard let str = try? String(contentsOf: url) else { return [] }
        let data = str.data(using: .utf8)!
        
        return try! JSONDecoder().decode(ResponseFromUD.self, from: data).list
    }
    
    static var previews: some View {
        WordPicker(wordsToPick: Self.egWords(), selectedWord: .constant(nil))
    }
}
