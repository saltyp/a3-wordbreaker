//
//  GameSummary.swift
//  WordBreaker
//
//  Created by danielringskog on 7/19/26.
//

import SwiftUI

struct GameSummary: View {
    let game: WordBreaker
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    CharSeqView(charSeq: game.lastAttempt, selection: .constant(0))
                        .frame(maxHeight: 65)
                }
                Text("^[\(game.attempts.count) attempt](inflect:true)") //^[...] makes noun attempt adjust to number
                ElapsedTime(startTime:game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
            }
            Spacer()
        }
        // to improve clickability : makes the row view occupy the full list row width & extra height to click
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
        .contentShape(Rectangle()) //
    }
}

#Preview(traits: .swiftData) {
    let masterWord = "WIN"
    let attemptedWords = ["WHY", "SIT","OWL"] //last in array = last attempted
    let newGame = WordBreaker(masterWord: masterWord, attemptedWords: attemptedWords)

     GameSummary(game: newGame)
}
