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
     GameSummary(game: previewGame())
}

// helper fxn ffor #Preview, as #Preview doesn't allow imperative for-loop
func previewGame() -> WordBreaker {
    let masterWord = "WIN"
    let attemptedWords = ["WHY", "SIT","OWL"] //last in array = last attempted
    var newGame = WordBreaker(masterWord: masterWord)
    for word in attemptedWords {
        // produce new attempt that will show matches
        newGame.guess.word = word
        newGame.guessIsValidWord = true
        newGame.attemptGuess()
    }
    return newGame
}
