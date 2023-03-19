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
                ForEach(vm.words) { word in
                    WordCardView(word: word)
                        .padding()
                }
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
        vm.words.removeAll()
        await vm.loadRandomWords()
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}
