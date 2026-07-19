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
    
    var body: some View {
        // shows a dynamic list of games played (req task #1)
        List(games, id: \.pegChoices) { game in
            GameSummary(game:game)
         }
        .listStyle(.plain)
        .onAppear {
            // Toy implementation:
            games.append(WordBreaker(masterWord: "WIN"))
            games.append(WordBreaker(masterWord: "LOSE"))
        }
    }
}

#Preview {
    GamesPlayed()
}
