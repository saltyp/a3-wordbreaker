//
//  GameList.swift
//  WordBreaker
//
//  Created by danielringskog on 7/21/26.
//

import SwiftUI
import SwiftData


struct GameList: View {
    
    // MARK: Data in
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings
    @Environment(\.modelContext) var modelContext
    private static let minWordLength = 3
    private static let maxWordLength = 6

    // MARK: Data shared with me
    @Binding var selection: WordBreaker?
    @Query private var games: [WordBreaker]
    
    // MARK: Data Owned by Me
    @State private var showSettingsEditor: Bool = false
    
    init(nameContains search : String = "", selection: Binding<WordBreaker?>) {
        _selection = selection
        let trimmedSearch = search.trimmingCharacters(in: .whitespacesAndNewlines)
        // break up query into 2 separate Query initializations to avoid SwiftData compiling predicate as relationship query:
        if trimmedSearch.isEmpty {
            _games = Query(sort: \WordBreaker.created, order: .reverse)
        } else {
            let uppercaseSearch = trimmedSearch.uppercased()  //all pegs are capital letters
            let predicate = #Predicate<WordBreaker> {game in
                game._attempts.contains {attempt in attempt.word.contains(uppercaseSearch)} }
            _games = Query(filter:predicate, sort: \WordBreaker.created, order: .reverse)
        }
    }
    
    var body: some View {
        
        List(selection:$selection) {
            ForEach(games) {game in
                NavigationLink(value:game) { //using value:game to only specify here what to show (ie label) with destination view specified below instead, & allow for List to update selection
                    GameSummary(game:game)
                    //                    .tag(game as WordBreaker?) // redundant but using due to buggy Canvas (see docs)
                }
            }
            .onDelete {offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
            .onChange(of: games.count) { // in case of deleting game that is selected , reset selection :
                if let selection, !games.contains(selection) {
                    self.selection = nil
                }
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
            modelContext.insert(WordBreaker(masterWord: "AWAIT"))
        } else {
            modelContext.insert(WordBreaker(masterWord: words.random(length: wordlen) ?? "ERROR"))
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
