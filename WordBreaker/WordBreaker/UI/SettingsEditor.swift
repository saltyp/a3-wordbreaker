//
//  SettingsEditor.swift
//  WordBreaker
//
//  Created by danielringskog on 8/31/26.
//

import SwiftUI

struct SettingsEditor: View {
    
    //MARK: Data owned by Me (for now;later to be shared with me)
    @State private var helperColors: [Color] = [.green,.blue,.red]
    @State private var helperColorMapping: [String] = ["Exact Match", "Near Match", "No Match"]
    @State private var defaultWordLength: Int = 4
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Keyboard Hint Colors") {
                    List {
                        ForEach(helperColors.indices, id: \.self) { index in
                            ColorPicker(
                                selection: $helperColors[index],
                                supportsOpacity: false
                            ) {
                                Text(helperColorMapping[index])
                            }
                        }
                        
                    }
                }
                Section("Default Word Length") {
                 Picker("Default Word Length", selection: $defaultWordLength) {
                     ForEach(2...10, id: \.self) {number in
                         Text("\(number)")
                     }
                 }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        //dismiss()
                    }
                }
                ToolbarItem(placement:.confirmationAction) {
                    Button("Done") {
                        //done()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsEditor()
}
