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
    @State private var search: String = ""
    
    // MARK: - body
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(nameContains: search, selection:$selection)
            .navigationTitle("Word Breaker")
            .searchable(text: $search)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
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

#Preview(traits: .swiftData) {
    GamesPlayed()
}
