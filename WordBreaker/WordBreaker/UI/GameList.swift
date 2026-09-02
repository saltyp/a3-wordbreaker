//
//  GameList.swift
//  WordBreaker
//
//  Created by danielringskog on 7/21/26.
//

import SwiftUI


struct GameList: View {
    
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings
    private static let minWordLength = 3
    private static let maxWordLength = 6

    // MARK: Data shared with me
    @Binding var selection: WordBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [WordBreaker] = []
    @State private var showSettingsEditor: Bool = false
    
    var body: some View {
        List(selection:$selection) {
            ForEach(games) {game in
                NavigationLink(value:game) { //using value:game to only specify here what to show (ie label) with destination view specified below instead, & allow for List to update selection
                GameSummary(game:game)
//                    .tag(game as WordBreaker?) // redundant but using due to buggy Canvas (see docs)
                }
            }
            .onDelete {offsets in games.remove(atOffsets: offsets)}
        }
        .onChange(of: games.count) { // in case of deleting game that is selected , reset selection :
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                settingsButton
            }
            ToolbarItem(placement:.confirmationAction) {
                addButton
            }
            ToolbarItem(placement:.confirmationAction) {
                EditButton()
            }
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    var settingsButton: some View {
        Button("Settings", systemImage: "gearshape") {
            showSettingsEditor = true
        }
        .sheet(isPresented: $showSettingsEditor, onDismiss: {showSettingsEditor = false}) {
            SettingsEditor()
        }
    }
    
    
    
    var addButton: some View {
        Menu("New Game", systemImage: "plus") {
            Section("Word Length: ") {
                ForEach(GameList.minWordLength...GameList.maxWordLength, id:\.self) {wordlen in
                        Button("\(wordlen)") {
                            withAnimation(.restart) {
                                addGame(wordlen:wordlen)
                            }
                        }
                    }
                Button("Default") {
                    addGame(wordlen:gameSettings.defaultWordLength)
                }
                }
        }
        .newGameButtonStyling()
    }
    
    func addGame(wordlen:Int) {
        if words.count == 0 { // no words (yet)
            games.insert(WordBreaker(masterWord: "AWAIT"), at: 0)
        } else {
            games.insert(WordBreaker(masterWord: words.random(length: wordlen) ?? "ERROR"), at:0)
        }
    }
    
    func addSampleGames() {
        // Toy implementation:
//        games.append(WordBreaker(masterWord: "LOSE", attemptedWords:["FOOL"]))
//        games.append(WordBreaker(masterWord: "WIN", attemptedWords: ["SIT", "OWL"]))
//        selection = games[Int.random(in:0..<games.count)]
    }
    
    var wordLength: Int {
        let wordLength:Int = Int.random(in:GameList.minWordLength...GameList.maxWordLength)
//        let wordLength:Int = 5
        return wordLength
    }
}

//#Preview {
//    GameList()
//}
