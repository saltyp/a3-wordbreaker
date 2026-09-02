//
//  GameSettings.swift
//  WordBreaker
//
//  Created by danielringskog on 9/1/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var gameSettings = GameSettings.shared
}

@Observable
class GameSettings {
    var helperColorMapping: [String] = ["Exact Match", "Near Match", "No Match"]
    var helperColors: [Color] = [.green,.blue,.gray]
    var defaultWordLength: Int = 4
    
    // singleton instance to share:
    static let shared = GameSettings()
    
    // singleton pattern
    private init() {
    }
    
}
