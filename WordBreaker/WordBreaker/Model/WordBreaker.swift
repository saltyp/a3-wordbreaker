//
//  WordBreaker.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import Foundation

typealias Peg = String // no need for enum Peg with just one var

enum Match: Int {
    case nomatch = 0
    case inexact
    case exact
}

enum ChoiceBestSoFar: Int {
    case notUsedYet = -1
    case nomatch
    case inexact
    case exact

    /// updates the state to best so far state
    mutating func update(_ other: Match) -> Void {
        let newValue = max(rawValue, other.rawValue)
        self = ChoiceBestSoFar(rawValue:newValue)!
    }
}


@Observable class WordBreaker {
    
    //MARK: Data In
    let masterWord: String //actually mutable since masterCharSeq is mutable!
    
    //MARK: - body
    static private let isMasterHidden = true
    var guessIsValidWord: Bool = false
    var masterCharSeq: CharSeq = CharSeq(kind: .mastercode(isHidden: isMasterHidden))
    var guess : CharSeq = CharSeq(kind: .guess)  // current guess in progress
    var attempts : [CharSeq] = [CharSeq]()  // all attempts made
    let pegChoices : [Peg] = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }// choices available to make a guess
    var pegChoiceRecord : [Peg:ChoiceBestSoFar]
    
    
    init(masterWord: String) {
        self.masterWord = masterWord
        self.masterCharSeq = CharSeq(kind: .mastercode(isHidden: WordBreaker.isMasterHidden), pegs: masterWord.map {String($0)})
        self.guess = CharSeq(kind: .guess, wordLength: masterWord.count)
        self.pegChoiceRecord = Dictionary( uniqueKeysWithValues: pegChoices.map { ($0, .notUsedYet) })
        print(masterWord)
    }
    
    // initializer for creating a mid-stream game with set attempts
    init(masterWord:String, attemptedWords:[String]) {
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
    
    
    //MARK: - body
    var isOver: Bool {
        attempts.last?.pegs == masterCharSeq.pegs
    }
    
    var lastAttempt: CharSeq { attempts.last ?? CharSeq(kind:.unknown, pegs: [CharSeq.missing]) }
    
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

