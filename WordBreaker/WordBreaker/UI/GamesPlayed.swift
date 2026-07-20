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
            // shows a dynamic list of games played (req task #1)
            List(games, selection:$selection) { game in
                NavigationLink {
                    WordBreakerView(game:game)
                } label: {
                    GameSummary(game:game)
                }
            }
//            {
//                ForEach(games) { game in
//                    NavigationLink {
//                        WordBreakerView(game: game)
//                    } label: {
//                        GameSummary(game:game)
//                    }
//                }
//            }
            .listStyle(.plain)
            .toolbar {
                addButton
                EditButton()
            }
            .navigationTitle("Word Breaker")
        } detail: { //rhs
            if let selection {
                WordBreakerView(game:selection)
                    .navigationTitle("Current game") //selection.name
//                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a Game!")
            }
        }
        .onAppear {
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
