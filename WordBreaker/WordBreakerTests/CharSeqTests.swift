//
//  CharSeqTests.swift
//  WordBreakerTests
//
//  Created by danielringskog on 9/7/26.
//

import Testing
@testable import WordBreaker

/// Unittests forCharSeq model
struct CharSeqTests {

    @Test func matchInexactNomatchLettersCorrectly() {
          let game = WordBreaker(masterWord: "PAST")
          game.guess.word = "STOP"
          let matches = game.guess.match(against: game.masterCharSeq)
          #expect(matches == [.inexact, .inexact, .noMatch, .inexact])
      }

    @Test func matchExactNomatchLettersCorrectly() {
          let game = WordBreaker(masterWord: "SOAP")
          game.guess.word = "STOP"
          let matches = game.guess.match(against: game.masterCharSeq)
          #expect(matches == [.exact, .noMatch, .inexact, .exact])
      }    
}
