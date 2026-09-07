//
//  WordBreakerTests.swift
//  WordBreakerTests
//
//  Created by danielringskog on 9/7/26.
//

import Testing
@testable import WordBreaker

/// Unittests for WordBreaker model
struct WordBreakerTests {

    @Test func pegChoicesContainTheEnglishAlphabet() {
        #expect(WordBreaker.pegChoices.count == 26)

        let expectedLetters = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) })
        let actualLetters = Set(WordBreaker.pegChoices)

        #expect(actualLetters == expectedLetters)
    }
    
    @Test func nonwordIsNotAttempted() {
          let game = WordBreaker(masterWord: "SOAP")
          game.guess.word = "SLOP"
          game.guessIsValidWord = true  //OBS is set by UITextChecker
          game.attemptGuess()
          game.guess.word = "SIOP"
          game.guessIsValidWord = false  //OBS is set by UITextChecker
          game.attemptGuess()
          let attempts = game.attempts.map({$0.word})
          #expect(attempts == ["SLOP"])
      }


}
