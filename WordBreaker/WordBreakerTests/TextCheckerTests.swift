//
//  TextCheckerTests.swift
//  WordBreakerTests
//
//  Created by danielringskog on 9/7/26.
//

import Testing
import UIKit  // for UITextChecker

@testable import WordBreaker

struct TextCheckerTests {

    @Test func validatesEnglishWords() {
          let checker = UITextChecker()

          #expect(checker.isAWord("slop"))
          #expect(!checker.isAWord("siop"))
      }

}
