//
//  GameSummary.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//
/* TODO: (#4) The List of games should show:
-  the last word attempted in each game
 - along with its proper peg-matching indication
 */

import SwiftUI

struct GameSummary: View {
    let game: WordBreaker
    
    var body: some View {
        HStack {
            CharSeqView(charSeq: game.lastAttempt, selection: .constant(0))
        }
    }
}

#Preview {
    let masterWord = "WIN"
    let attemptedWords = ["WHY", "SIT","OWL"] //last in array = last attempted
    var newGame = WordBreaker(masterWord: masterWord, attemptedWords: attemptedWords)

     GameSummary(game: newGame)
}
