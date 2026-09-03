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
    var helperPegColors: [Match: Color] = [.exact:.green, .inexact:.blue, .noMatch:.gray]
    var defaultWordLength: Int = 4
    
    // singleton instance to share:
    static let shared = GameSettings()
    
    // singleton pattern
    private init() {
    }
    
}
