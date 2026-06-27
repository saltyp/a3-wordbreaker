//
//  ContentView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import SwiftUI

struct WordBreakerView: View {
    @Environment(\.words) var words
        
    // MARK: Data Owned By Me
    @State private var game  = WordBreaker(masterWord: "apple")
    @State private var selection : Int = 0
    @State private var checker = UITextChecker()

    // MARK: - body
    
    var body: some View {
        VStack{
            view(for:game.masterCharSeq)
                .onChange(of: words.count, initial: true) {
                    if game.attempts.count == 0 { // don’t disrupt a game in progress
                        if words.count == 0 { // no words (yet)
                            game.masterCharSeq.word = "AWAIT"
                        } else {
                            game.masterCharSeq.word = words.random(length: 5) ?? "ERROR"
                        }
                    }
                }
            ScrollView {
                if !game.isOver {
                    view(for:game.guess)
                }
                Divider()
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
            newGameButton
            PegChooserView(choices:game.pegChoices) {peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.guess.pegs.count
            }
        }
        .padding()
    }
        
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                // let game decide game logic of whether to allow guessing invalid word :
                game.guessIsValidWord = checker.isAWord(game.guess.word.lowercased())
                print("\(game.guess.word.lowercased()): \(game.guessIsValidWord)")
                game.attemptGuess()
                selection = 0
            }
        }
        .padding(5)
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundStyle(.white)
        .clipShape(Capsule())
        .font(.system(size: GuessButton.maxFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    var newGameButton: some View {
        Button("New Game") {
            game = WordBreaker(masterWord: words.random(length: 5) ?? "ERROR")
        }
        .padding()
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundStyle(.white)
        .clipShape(Capsule())
        .font(.system(size: NewGameButton.maxFontSize))
        .minimumScaleFactor(NewGameButton.scaleFactor)
    }

    
    func view(for code:CharSeq) -> some View {
        HStack {
            CharSeqView(charSeq:code, selection: $selection)
            Rectangle().foregroundStyle(Color.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                        if code.kind == .guess {
                            guessButton
                    }
                }
            }
        }
    
    struct GuessButton {
        static let minFontSize : CGFloat = 10
        static let maxFontSize : CGFloat = 200
        static let scaleFactor = minFontSize/maxFontSize
    }
    
    struct NewGameButton {
        static let minFontSize : CGFloat = 3
        static let maxFontSize : CGFloat = 30
        static let scaleFactor = minFontSize/maxFontSize

    }
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}


#Preview {
    WordBreakerView()
}
