//
//  GamesPlayed.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI

struct GamesPlayed: View {
        
    // MARK: Data Owned by Me
    @State private var selection: WordBreaker? = nil
    
    // MARK: - body
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection:$selection)
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
    }
            
}

#Preview {
    GamesPlayed()
}
