//
//  GameSettings.swift
//  WordBreaker
//
//  Created by danielringskog on 9/1/26.
//

import SwiftUI
import SwiftData

extension EnvironmentValues {
    @Entry var gameSettings = GameSettings()
}


@Model
class GameSettings {
    var helperPegColors: [Match: String]
    var defaultWordLength: Int
    
    init(helperPegColors: [Match: String] = [.exact:Color.green.hex, .inexact:Color.blue.hex, .noMatch:Color.gray.hex],
         defaultWordLength: Int = 4) {
        self.helperPegColors = helperPegColors
        self.defaultWordLength = defaultWordLength
    }

}
