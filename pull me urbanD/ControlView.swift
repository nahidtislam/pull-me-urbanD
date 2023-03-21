//
//  ControlView.swift
//  pull me urbanD
//
//  Created by Nahid Islam on 18/03/2023.
//

import SwiftUI

struct ControlView: View {
    
    @StateObject var vm = ControlViewModel()
    
    @State private var selectedWord = ""
    @State private var showingWordPicker = false
    @State private var selectedWordFromPicker: UDWord?
    
    @State private var lineGradFlipped = false
    @State private var lineGradColors: [Color] = [.blue, .cyan, .mint, .yellow]
    
    var body: some View {
        VStack {
            if vm.errorHappened {
                errorDisplay
            } else if vm.words.count == 0 {
                Text("loading...")
            } else {
                theWords
            }
        }
        .task {
            await vm.loadRandomWords()
        }
        .refreshable {
            await vm.loadRandomWords()
        }
    }
    
    private var theWords: some View {
        ScrollView {
            TextField("search word", text: $selectedWord)
                .textFieldStyle(.roundedBorder).padding()
                .onSubmit {
                    Task {
                        await vm.load(word: selectedWord)
                    }
                }
            ScrollViewReader { proxy in
                list(words: vm.addedWords)
                if vm.addedWords.count > 0 { randomSep }
                if vm.randomWords.count == 0 { Text("randomising words") }
                list(words: vm.randomWords)
                .onChange(of: vm.scrollToID) { newValue in
                    guard let newValue else { return }
                    withAnimation(.spring()) {
                        proxy.scrollTo(newValue, anchor: .top)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        vm.scrollToID = nil
                    }
                }
            }
            Button("refresh") {
                Task {
                    await refreshWords()
                }
            }
        }
        .onChange(of: vm.wordsToPick) { newValue in
            showingWordPicker = newValue.count > 0
        }
        .sheet(isPresented: $showingWordPicker) {
            if vm.wordsToPick.count > 0 { vm.wordsToPick.removeAll() }
        } content: {
            WordPicker(wordsToPick: vm.wordsToPick, selectedWord: $selectedWordFromPicker)
                .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: selectedWordFromPicker, perform: vm.insertSelected)
    }
    
    private var errorDisplay: some View {
        VStack {
            Spacer()
            Text("oh no")
            Spacer()
            Button("try again") {
                Task { await vm.loadRandomWords() }
            }
        }
    }
    
    private func refreshWords() async {
        vm.errorHappened = false
        vm.randomWords.removeAll()
        await vm.loadRandomWords()
    }
    
    func list(words: [UDWord]) -> ForEach<[UDWord], Int, some View> {
        ForEach(words) { word in
            WordCardView(word: word)
                .padding()
        }
    }
    
    var randomSep: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(LinearGradient(colors: lineGradColors, startPoint: lineGradFlipped ? .trailing : .leading, endPoint: lineGradFlipped ? .leading : .trailing))
            .padding()
            .onAppear {
                withAnimation(.easeIn(duration: 5).repeatForever()) { lineGradColors.shuffle(); lineGradFlipped.toggle() }
            }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}
