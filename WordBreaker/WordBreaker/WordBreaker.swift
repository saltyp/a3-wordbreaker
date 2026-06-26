//
//  WordBreaker.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import Foundation

typealias Peg = String // no need for enum Peg with just one var

enum Match {
    case exact
    case inexact
    case nomatch
}

struct WordBreaker {
    //MARK: Data In
    let masterWord: String
    var masterCharSeq: CharSeq = CharSeq(kind: .mastercode(isHidden: false))
    var guess : CharSeq = CharSeq(kind: .guess)  // current guess in progress
    var attempts : [CharSeq] = [CharSeq]()  // all attempts made
    let pegChoices : [Peg] // choices available to make a guess

    init(masterWord: String) {
        self.masterWord = masterWord
        self.pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0).lowercased() }
        self.masterCharSeq = CharSeq(kind: .mastercode(isHidden: false), pegs: masterWord.map {String($0)})
        self.guess = CharSeq(kind: .guess, wordLength: masterWord.count)
    }
        
    //MARK: - body
    var isOver: Bool {
        attempts.last?.pegs == masterCharSeq.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess  // change kind of Code to an attempt, from a guess
        attempt.kind = .attempt(guess.match(against: masterCharSeq))  // set kind to an attempt with the associated data of (calculated) matches
        attempts.append(attempt) // now attempt can be added to attempts
        guess.reset()
        if isOver {
            masterCharSeq.kind = .mastercode(isHidden: false)
        }
    }
    
    /// Assign the guess peg at supplied index to the supplied peg
    mutating func setGuessPeg(_ peg:Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    /// Changes the pointed-at peg by cycling sequentially through the array pegChoices's elements
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count] // modulo as need to wrap around if at last index
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? CharSeq.missing
        }
    }
}

