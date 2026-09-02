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
//    var helperColorMapping: [String] = ["Exact Match", "Near Match", "No Match"]
//    var helperColors: [Color] = [.green,.blue,.gray]
    var helperColors: [HelperKind: Color] = [.exact:.green, .inexact:.blue, .noMatch:.gray]
    var defaultWordLength: Int = 4
    
    // singleton instance to share:
    static let shared = GameSettings()
    
    // singleton pattern
    private init() {
    }
    
    enum HelperKind: CaseIterable {
        case exact
        case inexact
        case noMatch
        
        var label: String {
            switch self {
            case .exact: "Exact Match"
            case .inexact: "Near Match"
            case .noMatch: "No Match"
            }
        }
    }
    
    
    
}
