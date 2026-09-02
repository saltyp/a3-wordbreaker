//
//  SettingsEditor.swift
//  WordBreaker
//
//  Created by danielringskog on 8/31/26.
//

import SwiftUI

struct SettingsEditor: View {
    
    //MARK: Data Shared with Me
    @Environment(\.dismiss) var dismiss  //to dismiss screen
    @Environment(\.words) var words
    @Environment(\.gameSettings) var gameSettings  // gives read.write access to object, but does not bind yet
    
    //MARK: Data Owned by Me
    @State private var draft = GameSettingsDraft()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Keyboard Hint Colors") {
                    List {
                        ForEach(draft.helperColors.indices, id: \.self) { index in
                            ColorPicker(
                                selection: $draft.helperColors[index],
                                supportsOpacity: false
                            ) {
                                Text(gameSettings.helperColorMapping[index])
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
}

/// struct to store and then eventually apply if settings screen is "Done" clicked
struct GameSettingsDraft {
    var helperColors: [Color]
    var defaultWordLength: Int
    
    init() {
        self.helperColors = [.red,.blue, .yellow]
        self.defaultWordLength = 4
    }
    
    init(from settings: GameSettings) {
        self.helperColors = settings.helperColors
        self.defaultWordLength = settings.defaultWordLength
    }
    
    func apply(to settings:GameSettings) {
        settings.helperColors = helperColors
        settings.defaultWordLength = defaultWordLength
    }
}

#Preview {
    SettingsEditor()
}
