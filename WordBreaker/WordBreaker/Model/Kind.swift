//
//  Kind.swift
//  WordBreaker
//
//  Created by danielringskog on 9/4/26.
//
//  with code created by ChatGPT on 5/12/25.
//  Prompt: enhance this enum to make it convertible to and from a string: <paste Kind with Match embedded>
//  Followup Prompt: don't use Codable
//  Followup Prompt: make the from function be a non-failable initializer



    enum Kind : Equatable { //define enum as Equatable so that we automatically get '==' fxn w/o needing to define it
        case mastercode(isHidden:Bool)
        case guess
        case attempt([Match]) //associated data
        case unknown

        // MARK: - CustomStringConvertible

        var description: String {
            switch self {
            case .mastercode(let isHidden):
                return "master(\(isHidden))"
            case .guess:
                return "guess"
            case .attempt(let matches):
                let matchStr = matches.map { String($0.rawValue) }.joined(separator: ",")
                return "attempt(\(matchStr))"
            case .unknown:
                return "unknown"
            }
        }

        // MARK: - Non-Failable Initializer

        init(_ string: String) {
            if string == "guess" {
                self = .guess
                return
            }

            if string == "unknown" {
                self = .unknown
                return
            }

            if string.hasPrefix("master("), string.hasSuffix(")") {
                let inner = String(string.dropFirst("master(".count).dropLast())
                switch inner {
                case "true":
                    self = .mastercode(isHidden: true)
                    return
                case "false":
                    self = .mastercode(isHidden: false)
                    return
                default:
                    break
                }
            }

            if string.hasPrefix("attempt("), string.hasSuffix(")") {
                let inner = String(string.dropFirst("attempt(".count).dropLast())
                let matchStrings = inner.split(separator: ",").map(String.init)
                let matches = matchStrings.compactMap {
                    if let value = Int($0) {
                        Match(rawValue: value)
                    } else {
                        nil
                    }
                }
                self = .attempt(matches)
                return
            }

            self = .unknown
        }
    }

