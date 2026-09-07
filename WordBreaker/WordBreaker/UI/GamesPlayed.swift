//
//  GamesPlayed.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI
import SwiftData

struct GamesPlayed: View {
        
    //MARK: Data In
    @Environment(\.modelContext) private var modelContext
    @Query private var _gameSettings: [GameSettings]

    private var gameSettings:GameSettings {
        _gameSettings.first ?? GameSettings()
    }

    // MARK: Data Owned by Me
    @State private var selection: WordBreaker? = nil
    @State private var search: String = ""
    @State private var showOption: GameList.ShowOption = .all
    
    // MARK: - body
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Show", selection: $showOption) {
                ForEach(GameList.ShowOption.allCases, id: \.self) {option in Text(option.title)}
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(show: showOption, nameContains: search, selection:$selection)
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
        .environment(\.gameSettings, gameSettings)
        .navigationSplitViewStyle(.balanced)
        .task {
            if _gameSettings.isEmpty {
                modelContext.insert(GameSettings())
            }
        }
    }
}

#Preview(traits: .swiftData) {
    GamesPlayed()
}
