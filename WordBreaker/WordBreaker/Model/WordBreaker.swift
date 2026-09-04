//
//  WordBreaker.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import Foundation
import SwiftData

typealias Peg = String // no need for enum Peg with just one var

enum Match: Int, CaseIterable {
    case noMatch = 0
    case inexact
    case exact
    
    var label: String {
        switch self {
        case .exact: "Exact Match"
        case .inexact: "Near Match"
        case .noMatch: "No Match"
        }
    }

}

enum ChoiceBestSoFar: Int, Codable {
    case notUsedYet = -1
    case noMatch
    case inexact
    case exact

    /// updates the state to best so far state
    mutating func update(_ other: Match) -> Void {
        let newValue = max(rawValue, other.rawValue)
        self = ChoiceBestSoFar(rawValue:newValue)!
    }
}


@Model class WordBreaker {
    
    //MARK: Data In
    var masterWord: String //actually mutable since masterCharSeq is mutable!
    
    //MARK: - body
    static private let isMasterHidden = true
    var guessIsValidWord: Bool = false
    @Relationship(deleteRule: .cascade) var masterCharSeq: CharSeq = CharSeq(kind: .mastercode(isHidden: isMasterHidden))
    @Relationship(deleteRule: .cascade) var guess : CharSeq = CharSeq(kind: .guess)  // current guess in progress
    @Relationship(deleteRule: .cascade) var attempts : [CharSeq] = [CharSeq]()  // all attempts made
    var pegChoices : [Peg] //= "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }// choices available to make a guess
    var pegChoiceRecord : [Peg:ChoiceBestSoFar]
    
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
    
    init(masterWord: String) {
        let pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }  //TODO: clean this up w static let alphabet, static let pegChoices, self.pegChoices = WordBreaker.pegChoices
        self.pegChoices = pegChoices
        self.masterWord = masterWord
        self.masterCharSeq = CharSeq(kind: .mastercode(isHidden: WordBreaker.isMasterHidden), pegs: masterWord.map {String($0)})
        self.guess = CharSeq(kind: .guess, wordLength: masterWord.count)
        self.pegChoiceRecord = Dictionary( uniqueKeysWithValues: pegChoices.map { ($0, .notUsedYet) })
        print(masterWord)
    }
    
    // initializer for creating a mid-stream game with set attempts
    init(masterWord:String, attemptedWords:[String]) {
        let pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        self.pegChoices = pegChoices
        self.masterWord = masterWord
        self.masterCharSeq = CharSeq(kind: .mastercode(isHidden: WordBreaker.isMasterHidden), pegs: masterWord.map {String($0)})
        self.guess = CharSeq(kind: .guess, wordLength: masterWord.count)
        self.pegChoiceRecord = Dictionary( uniqueKeysWithValues: pegChoices.map { ($0, .notUsedYet) })
        for word in attemptedWords {
            // produce new attempt that will show matches
            self.guess.word = word
            self.guessIsValidWord = true
            self.attemptGuess()
        }
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001 //hack to force SwiftUI to update due to @Transient bug
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    
    var isOver: Bool {
        attempts.last?.pegs == masterCharSeq.pegs
    }
    
    var lastAttempt: CharSeq { attempts.last ?? guess }
    
    func attemptGuess() {
        // Ignore attempts by the user that they’ve already tried before
        //TODO: not working
        if attempts.firstIndex(where: { $0 == guess }) != nil { return }
        // ignore attempts for which have no pegs chosen at all:
        if guess.pegs.allSatisfy({$0 == CharSeq.missing}) { return }
        // ignore attempts where the charseq is not a valid word
        if !guessIsValidWord { return }
        
        var attempt = guess  // change kind of Code to an attempt, from a guess
        let matches = guess.match(against: masterCharSeq)
        attempt.kind = .attempt(matches)  // set kind to an attempt with the associated data of (calculated) matches
        // TODO: better to use this with enum kind
        for index in 0..<attempt.pegs.count {
            pegChoiceRecord[attempt.pegs[index]]?.update(matches[index])
        }
        // now attempt can be added to attempts
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCharSeq.kind = .mastercode(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    /// Assign the guess peg at supplied index to the supplied peg
    func setGuessPeg(_ peg:Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    /// Changes the pointed-at peg by cycling sequentially through the array pegChoices's elements
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count] // modulo as need to wrap around if at last index
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? CharSeq.missing
        }
    }
}

extension WordBreaker: Identifiable, Hashable {
    static func == (lhs:WordBreaker, rhs:WordBreaker) -> Bool {
        //equal if pointers equal
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

