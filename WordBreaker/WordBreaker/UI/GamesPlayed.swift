//
//  GamesPlayed.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI

struct GamesPlayed: View {
    
    // MARK: Data Owned by Me
    @State private var games: [WordBreaker] = []
//    @State private var selection: WordBreaker? = nil
    
    // MARK: - body
    var body: some View {
        NavigationStack{
            // shows a dynamic list of games played (req task #1)
            List($games, id: \.masterWord) { $game in
                NavigationLink {
                    WordBreakerView(game: $game)
                } label: {
                    GameSummary(game:game)
                }
             }
            .listStyle(.plain)
        }
        .onAppear {
            // Toy implementation:
            games.append(WordBreaker(masterWord: "LOSE", attemptedWords:["FOOD"]))
            games.append(WordBreaker(masterWord: "WIN", attemptedWords: ["SIT", "OWL"]))
        }
    }
}

#Preview {
    GamesPlayed()
}
