//
//  GamesPlayed.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI

struct GamesPlayed: View {
    
    //TODO: why does this keep refreshing the call to https: ? Is it just a function of Canvas view?
    @Environment(\.words) var words
    private static let minWordLength = 3
    private static let maxWordLength = 6
    
    // MARK: Data Owned by Me
    @State private var games: [WordBreaker] = []
    @State private var selection: WordBreaker? = nil
    
    // MARK: - body
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            // lhs summary pane of split view
            List(selection:$selection) {
                ForEach(games) {game in
                    NavigationLink(value:game) { //using value:game to only specify here what to show (ie label) with destination view specified below instead, & allow for List to update selection
                        GameSummary(game:game)
                    }
                }
                .onDelete {offsets in games.remove(atOffsets: offsets)}
                
            }
            .listStyle(.plain)
            .toolbar {
                addButton
                EditButton()
            }
            .navigationTitle("Word Breaker")
        } detail: {
            if let selection {
                WordBreakerView(game:selection)
                    .navigationTitle("Current game") //selection.name
            } else {
                Text("Choose a Game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear { // Toy implementation:
//            games.append(WordBreaker(masterWord: "LOSE", attemptedWords:["FOOL"]))
//            games.append(WordBreaker(masterWord: "WIN", attemptedWords: ["SIT", "OWL"]))
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            addGame()
        }
    }
    
    var wordLength: Int {
        let wordLength:Int = Int.random(in:GamesPlayed.minWordLength...GamesPlayed.maxWordLength)
//        let wordLength:Int = 5
        return wordLength
    }
    
    func addGame() {
        if words.count == 0 { // no words (yet)
            games.insert(WordBreaker(masterWord: "AWAIT"), at: 0)
        } else {
            games.insert(WordBreaker(masterWord: words.random(length: wordLength) ?? "ERROR"), at:0)
        }
    }
}

#Preview {
    GamesPlayed()
}
