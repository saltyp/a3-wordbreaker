//
//  Words.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import SwiftUI

// since var words and shared are open to all actors, it is not threadsafe (especially as non-singleton is used here)
extension EnvironmentValues { //EnvironmentValues @Entry do not allow actor isolation 
    @Entry var words = Words.shared
}

@MainActor //make entire Words be isolated to the MainActor
@Observable
class Words {
    private var words = Dictionary<Int, Set<String>>()
    
    static let shared = //now only can be read/written by code on the MainActor (eg UI)
        Words(from: URL(string: "https://web.stanford.edu/class/cs193p/common.words"))

    private init(from url: URL? = nil) {
        Task {
            words = await load(from: url)
            if count > 0 {
                print("Words loaded \(count) words from \(url?.absoluteString ?? "nil")")
            }
        }
    }
    
    private func load(from url: URL?) async -> Dictionary<Int, Set<String>> {
        var _words = [Int:Set<String>]()
        if let url {
            do {
                for try await word in url.lines {
                    _words[word.count, default: Set<String>()].insert(word.uppercased())
                }
            } catch {
                print("Words could not load words from \(url): \(error)")
            }
        }
        return _words
    }
    
    var count: Int {
        words.values.reduce(0) { $0 + $1.count }
    }
    
    func contains(_ word: String) -> Bool {
        words[word.count]?.contains(word.uppercased()) == true
    }

    func random(length: Int) -> String? {
        let word = words[length]?.randomElement()
        if word == nil {
            print("Words could not find a random word of length \(length)")
        }
        return word
    }
    
    func numWordsOfLength(_ length: Int) -> Int {
        return words[length]?.count ?? 0
    }

}

extension UITextChecker {
    func isAWord(_ word: String) -> Bool {
        rangeOfMisspelledWord(
            in: word,
            range: NSRange(location: 0, length: word.utf16.count),
            startingAt: 0,
            wrap: false,
            language: "en_US"
        ).location == NSNotFound
    }
}
