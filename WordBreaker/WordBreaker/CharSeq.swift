//
//  CharSeq.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import Foundation

struct CharSeq {
    //MARK: Data In
    var kind : Kind
    var pegs : [Peg]
    var seqLength: Int
    
    static let missing : Peg = ""
    
    init(kind: Kind, wordLength: Int = 4) {
        self.kind = kind
        self.seqLength = wordLength
        self.pegs = Array(repeating: CharSeq.missing, count: wordLength)
        
    }
    
    init(kind: Kind, pegs: [Peg]) {
        self.kind = kind
        self.pegs = pegs
        self.seqLength = pegs.count
    }
    
    // get/set the pegs in a Code to a word
    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map { String($0) } }
    }
    
    enum Kind : Equatable { //define enum as Equatable so that we automatically get '==' fxn w/o needing to define it
        case mastercode(isHidden:Bool)
        case guess
        case attempt([Match]) //associated data
        case unknown
    }
    
//    mutating func randomize(from pegChoices: [Peg]) {
//        for ix in pegs.indices {
//            pegs[ix] = pegChoices.randomElement() ?? Code.missingPeg
//        }
//    }
    
    var isHidden: Bool {
        switch kind {
            case .mastercode(let isHidden): return isHidden
            default: return false
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: CharSeq.missing, count: seqLength)
    }
    
    var matches : [Match]? {
        switch kind {
        case .attempt(let matches) : return matches
        default: return nil
        }
    }
    
    /// Calculates what type of match for each peg : eg returns [.inexact, .exact, .nomatch, .exact]
    func match(against otherCode: CharSeq) -> [Match] {
        var pegsToMatch = otherCode.pegs  //mutable
        // calculate exact matches: eg results -> [.nomatch, .exact, .nomatch, .exact]
        let backwardsExactMatches = pegs.indices.reversed().map {index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]  {
                pegsToMatch.remove(at: index)  // eg mastercode pegs removed to avoid double count
                return Match.exact
            } else {
                return .nomatch
            }
        }
        // calculate inexact matches eg results -> [.inexact, .exact, .nomatch, .exact]
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map {index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    pegsToMatch.remove(at: matchIndex)
                    return .inexact
                } else {
                    return exactMatches[index]
                }
        }
    }
}
