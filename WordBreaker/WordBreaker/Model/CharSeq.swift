//
//  CharSeq.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import Foundation
import SwiftData

@Model class CharSeq : Equatable {
    //MARK: Data In
    var _kind : String = Kind.unknown.description
    var pegs : [Peg]
    var seqLength: Int
    var timestamp = Date.now  // to maintain order of games
    
    static let missing : Peg = ""
    
    var kind: Kind {
        get { return Kind(_kind) }
        set { _kind = newValue.description}
    }
    
    /// empty initializer
    init(kind: Kind, wordLength: Int = 4) {
        self.seqLength = wordLength
        self.pegs = Array(repeating: CharSeq.missing, count: wordLength)
        self.kind = kind
    }
    
    /// non-empty initializer
    init(kind: Kind, pegs: [Peg]) {
        self.pegs = pegs
        self.seqLength = pegs.count
        self.kind = kind
    }
        
    /// get/set the pegs in a Code to a String
    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map { String($0) } }
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
    
    func reset() {
        pegs = Array(repeating: CharSeq.missing, count: seqLength)
    }
    
    /// returns matches array if this is an attempt
    var matches : [Match]? {
        switch kind {
            case .attempt(let matches) : return matches
            default: return nil
        }
    }
    
    /// Calculates what type of match for each peg : eg returns [Match.inexact, .exact, .nomatch, .exact]
    func match(against otherCode: CharSeq) -> [Match] {
        var pegsToMatch = otherCode.pegs  //mutable
        // calculate exact matches: eg results -> [.nomatch, .exact, .nomatch, .exact]
        let backwardsExactMatches = pegs.indices.reversed().map {index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]  {
                pegsToMatch.remove(at: index)  // eg mastercode pegs removed to avoid double count
                return Match.exact
            } else {
                return .noMatch
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
