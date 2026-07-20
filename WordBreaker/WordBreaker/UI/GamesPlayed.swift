//
//  GamesPlayed.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI

struct GamesPlayed: View {
    
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var games: [WordBreaker] = []
//    @State private var selection: WordBreaker? = nil
    
    // MARK: - body
    var body: some View {
        NavigationStack{
            // shows a dynamic list of games played (req task #1)
            List(games) { game in
                NavigationLink {
                    WordBreakerView(game: game)
                } label: {
                    GameSummary(game:game)
                }
             }
            .listStyle(.plain)
            .toolbar {
                addButton
            }
        }
        .onAppear {
            // Toy implementation:
            games.append(WordBreaker(masterWord: "LOSE", attemptedWords:["FOOL"]))
            games.append(WordBreaker(masterWord: "WIN", attemptedWords: ["SIT", "OWL"]))
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            if words.count == 0 { // no words (yet)
                games.insert(WordBreaker(masterWord: "AWAIT"), at: 0)
            } else {
                let wordLength:Int = 5
                games.insert(WordBreaker(masterWord: words.random(length: wordLength) ?? "ERROR"), at:0)
            }
        }
    }
}

#Preview {
    GamesPlayed()
}
