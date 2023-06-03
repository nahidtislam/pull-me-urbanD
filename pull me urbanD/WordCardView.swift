//
//  WordCardView.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 18/03/2023.
//

import SwiftUI

struct WordCardView: View {
    
    let word: UDWord
    var bordered = true
    
    enum Rating {
    case like, dislike
        
        var color: Color? {
            switch self {
            case .like: return .green
            case .dislike: return .red
            }
        }
        
        var image: Image? {
            switch self {
            case .like: return .init(systemName: "hand.thumbsup.circle.fill")
            case .dislike: return .init(systemName: "hand.thumbsdown.circle")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Text(word.word)
                    .font(.largeTitle)
                Text(attribute(string: word.definition, font: .subheadline.italic()))
            }
            Text("example: ")
                .font(.caption.bold())
                .foregroundColor(.accentColor) +
                Text(attribute(string: word.example, font: .caption.bold()))
                    .font(.caption)
            HStack {
                stat(rating: .like, word.thumbsUp)
                stat(rating: .dislike, word.thumbsDown)
            }
            Text("date: ").foregroundColor(.purple).font(.caption2) + Text(word.writtenOnDate.formatted(date: .numeric, time: .omitted)/*Text(word.writtenOnDate, style: .date*/)
                .font(.caption2.italic())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30, style: .circular)
                .stroke(style: .init(lineWidth: bordered ? 2 : 0, lineCap: .butt, lineJoin: .round, dash: [0, 5, 8]))
        )
        
    }
    
    private func attribute(string: String, font: Font) -> AttributedString {
        let string = string.replacingOccurrences(of: "\r", with: "")
//        var live = string
        var output = AttributedString(string)
        let b = output
        var offsetting = 0
        
        let ranges = string.ranges(of: /\[([^\]]+)\]/)
        
//        ranges.forEach { range in
//            return
//            let brackted = String(string[range])
//            let bracketlessIndexes = string.index(range.lowerBound, offsetBy: 1)..<string.index(range.upperBound, offsetBy: -1)
//            let bracketless = String(string[bracketlessIndexes])
//
//            let distToEdited = string.distance(from: live.firstRange(of: brackted)!.lowerBound, to: bracketlessIndexes.lowerBound)
//
//            let indexesToFormat = live.index(range.lowerBound, offsetBy: 0)..<string.index(range.upperBound, offsetBy: -2)
//
//            live = NSAttributedString(output).string
//        }
        
        ranges.forEach { range in
            let lowIndex = string.index(range.lowerBound, offsetBy: -offsetting)
            let upIndex = string.index(range.upperBound, offsetBy: -2 - offsetting)
            let low = AttributedString.Index(lowIndex, within: b)!
            let up = AttributedString.Index(upIndex, within: b)!
            
            output.removeSubrange(low..<output.index(afterCharacter: low))
            output.removeSubrange(up..<output.index(afterCharacter: up))
            
            let newLineCount = string[lowIndex..<upIndex].filter({ $0 == "\n" }).count

            offsetting += 2 + newLineCount
            
            let strInBrackets = string[range]
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
            
            output[low..<up].font = font
            output[low..<up].link = UrbanDictAPI.selected(word: strInBrackets).url
            output[low..<up].foregroundColor = .mint
        }
        
        return output
    }
    
    func ratioScale(rating: Rating, minimumDelta: CGFloat = 0.75, maximumDelta: CGFloat = 1.5, deltaFactor: CGFloat = 3) -> CGSize {
        func divide(_ x: Int, by y: Int) -> CGFloat { CGFloat(x) / CGFloat(y) }
        
        let val: CGFloat
        switch rating {
        case .like: val = divide(word.thumbsUp, by: word.thumbsDown)
        case .dislike: val = divide(word.thumbsDown, by: word.thumbsUp)
        }
        
        let len = max(minimumDelta, min(maximumDelta, val))
        let delta = 1 - (len / deltaFactor)
        
        return .init(width: len, height: len)
        
    }
    
    func stat(rating: Rating, _ value: Int) -> some View {
        HStack {
            rating.image
            Text("\(value)")
        }
        .foregroundColor(.white)
        .padding(6)
        .padding(.trailing, 2)
        .background(rating.color.saturation(0.9))
        .cornerRadius(20)
    }
}

struct WordCardView_Previews: PreviewProvider {
    
    static let egWord = UDWord(defid: 679, word: "nice", definition: "this is a \"nice\" word", example: "WOW! This [word] is very nice", thumbsUp: 67567, thumbsDown: 2, currentVote: "", writtenOn: "2023-01-19T00:09:10.123Z", author: "swioft", permalink: ".downloadsDirectory")
    
    static var previews: some View {
        WordCardView(word: Self.egWord)
    }
}
