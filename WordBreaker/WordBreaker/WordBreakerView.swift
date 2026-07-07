//
//  ContentView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import SwiftUI

struct WordBreakerView: View {
    //TODO: why does this keep refreshing the call to https: ? Is it just a function of Canvas view?
    @Environment(\.words) var words
    private static let minWordLength = 3
    private static let maxWordLength = 6
    
    // MARK: Data Owned By Me
    @State private var game  = WordBreaker(masterWord: "Apple")
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
                            let wordLength:Int = Int.random(in:WordBreakerView.minWordLength...WordBreakerView.maxWordLength)
                            // reset game, not just masterword so that guess sequence is consistent (ie same #)
                            game = WordBreaker(masterWord: words.random(length: wordLength) ?? "ERROR")
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
            HStack {
                PegChooserView(
                    choices:game.pegChoices,
                    bestSoFars: game.pegChoiceRecord,
                    onChoose: {peg in
                        game.setGuessPeg(peg, at: selection)
                        selection = (selection + 1) % game.guess.pegs.count
                    },
                    onGuess : {
                        withAnimation {
                            game.guessIsValidWord = checker.isAWord(game.guess.word.lowercased())
                            game.attemptGuess()
                            selection = 0
                        }
                    },
                    onErase: {
                        selection = max(0,selection - 1)
                        //TODO: reduce coupling here:
                        game.setGuessPeg(CharSeq.missing, at: selection)
                    }
                )
            }
        }
        .padding()
    }
                
    var newGameButton : some View {
        Menu("New Game") {
            Section("Word Length: ") {
                ForEach(WordBreakerView.minWordLength...WordBreakerView.maxWordLength, id:\.self) {wordlen in
                        Button("\(wordlen)") {
                            game = WordBreaker(masterWord: words.random(length: wordlen) ?? "ERROR")
                        }
                    }
            }
        }
        .newGameButtonStyling()
    }

    
    func view(for code:CharSeq) -> some View {
        HStack {
            CharSeqView(charSeq:code, selection: $selection)
            }
        }
    
    struct GuessButton {
        static let minFontSize : CGFloat = 10
        static let maxFontSize : CGFloat = 200
        static let scaleFactor = minFontSize/maxFontSize
    }
    
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

extension View {
    func newGameButtonStyling(minimum: CGFloat = 3, maximum:CGFloat = 30) -> some View {
        self
          .font(.system(size: maximum))
          .minimumScaleFactor(minimum/maximum)
          .foregroundStyle(.white)
          .padding()
          .background(Color(red: 0, green: 0, blue: 0.5))
          .clipShape(Capsule())
    }
}



#Preview {
    WordBreakerView()
}
