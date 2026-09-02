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
    
    
    var body: some View {
        @Bindable var gameSettings = gameSettings  // binding to above gameSettings
        
        NavigationStack {
            Form {
                Section("Keyboard Hint Colors") {
                    List {
                        ForEach(gameSettings.helperColors.indices, id: \.self) { index in
                            ColorPicker(
                                selection: $gameSettings.helperColors[index],
                                supportsOpacity: false
                            ) {
                                Text(gameSettings.helperColorMapping[index])
                            }
                        }
                        
                    }
                }
                Section("Default Word Length") {
                    Picker("Default Word Length", selection: $gameSettings.defaultWordLength) {
                     ForEach(2...10, id: \.self) {number in
                         Text("\(number) (\(words.numWordsOfLength(number)) words)")
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
                        // TODO: copy over settings
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    SettingsEditor()
}
