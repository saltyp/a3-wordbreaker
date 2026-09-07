//
//  SettingsEditor.swift
//  WordBreaker
//
//  Created by danielringskog on 8/31/26.
//

import SwiftUI
import SwiftData

struct SettingsEditor: View {
    
    //MARK: Data Shared with Me
    @Environment(\.dismiss) var dismiss  //to dismiss screen
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings

    //MARK: Data Owned by Me
    @State private var draft = GameSettingsDraft()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Keyboard Hint Colors") {
                    List {
                        ForEach(Match.allCases, id: \.self) { kind in
                            ColorPicker(
                                selection: colorBinding(for: kind),
                                supportsOpacity: false
                            ) {
                                Text(kind.label)
                            }
                        }
                    }
                }
                Section("Default Word Length") {
                    Picker("Default Word Length", selection: $draft.defaultWordLength) {
                        ForEach(2...10, id: \.self) {number in
                            let numAvailableWords = words.numWordsOfLength(number)
                            if numAvailableWords > 0 {
                                Text("\(number) (\(numAvailableWords) words)")
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement:.confirmationAction) {
                    Button("Done") {
                        draft.apply(to: gameSettings)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            draft = GameSettingsDraft(from: gameSettings)
        }
    }
    
    func colorBinding(for kind: Match)-> Binding<Color> {
        Binding<Color>(
            get: { draft.helperColors[kind] ?? .gray },
            set: { draft.helperColors[kind] = $0 }
        )
    }
    
}

/// struct to store and then eventually apply if settings screen is "Done" clicked
struct GameSettingsDraft {
    var helperColors: [Match: Color]
    var defaultWordLength: Int
    
    init() {
        self.helperColors = [.exact:.green, .inexact:.blue, .noMatch:.gray]
        self.defaultWordLength = 4
    }
    
    init(from settings: GameSettings) {
        self.helperColors = settings.helperPegColors.mapValues {Color(hex:$0) ?? .black}  
        self.defaultWordLength = settings.defaultWordLength
    }
    
    func apply(to settings:GameSettings) {
        settings.helperPegColors = helperColors.mapValues {$0.hex}
        settings.defaultWordLength = defaultWordLength
    }
}

#Preview(traits: .swiftData) {
    SettingsEditor()
}
