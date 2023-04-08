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
        VStack {
            Text("select a definition for **\(sortedWords.first!.word)**")
                .font(.title)
                .padding()
            wordScroll
        }
    }
    
    var wordScroll: some View {
        ScrollView {
            ForEach(sortedWords) { word in
                Button {
                    selectedWord = word
                } label: {
                    display(word: word)
                        .padding()
                }
                .buttonStyle(Press())

            }
        }
    }
    
    private func display(word: UDWord) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(word.word)
                .font(.largeTitle)
                .foregroundColor(.primary)
            Text(word.definition.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""))
                .font(.caption)
                .foregroundColor(.primary)
            Label("votes: \(word.thumbs_up - word.thumbs_down)", systemImage: "arrow.\(word.thumbs_up >= word.thumbs_down ? "up" : "down").circle")
                .foregroundColor(word.thumbs_up >= word.thumbs_down ? .teal : .red)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor, lineWidth: 3))
    }
    
    struct Press: ButtonStyle {
        
        private func scale(pressed: Bool) -> CGSize {
            let len = pressed ? 0.8 : 1
            return .init(width: len, height: len)
        }
        
        private func rotation(pressed: Bool) -> Angle {
            return .init(radians: pressed ? .pi / 6 : 0)
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(scale(pressed: configuration.isPressed))
                .opacity(configuration.isPressed ? 0.8 : 1)
                .saturation(configuration.isPressed ? 0.5 : 1)
                .rotation3DEffect(rotation(pressed: configuration.isPressed), axis: (x: -0.1, y: 1, z: 0.2))
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.8), value: configuration.isPressed)
        }
    }
}

//struct WordPicker_Previews: PreviewProvider {
//    static func egWords() -> [UDWord] {
//        let url = Bundle.main.url(forResource: "wordpicker-list", withExtension: "json")!
//        guard let str = try? String(contentsOf: url) else { return [] }
//        let data = str.data(using: .utf8)!
//        
//        return try! JSONDecoder().decode(ResponseFromUD.self, from: data).list
//    }
//    
//    static var previews: some View {
//        WordPicker(wordsToPick: Self.egWords(), selectedWord: .constant(nil))
//    }
//}
