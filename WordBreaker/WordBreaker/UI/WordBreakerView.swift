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
                        .animation(nil, value:game.attempts.count)
                }
                Divider()
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }.transition(.attempt(game.isOver)) //transition defined on entire CodeView
            }
                newGameButton
                if !game.isOver {
                    PegChooserView(
                        choices:game.pegChoices,
                        bestSoFars: game.pegChoiceRecord,
                        onChoose: {peg in
                            game.setGuessPeg(peg, at: selection)
                            selection = (selection + 1) % game.guess.pegs.count
                        },
                        leftExtraButton: { guessQWERTYButton },
                        rightExtraButton: { eraseButton }
                    )
                    .transition(.keyboard) // to move keyboard down instead of opacity
                }
        }
        .padding()
    }
                
    var newGameButton : some View {
        Menu("New Game") {
            Section("Word Length: ") {
                ForEach(WordBreakerView.minWordLength...WordBreakerView.maxWordLength, id:\.self) {wordlen in
                        Button("\(wordlen)") {
                            withAnimation(.restart) {
                                game = WordBreaker(masterWord: words.random(length: wordlen) ?? "ERROR")
                            }
                        }
                    }
                }
        }
        .newGameButtonStyling()
    }
    
    var guessQWERTYButton: some View {
        Button("Guess") {guess()}
            .foregroundStyle(.black)
        .frame(width: 2*ChoiceLayout.buttonWidth, height: ChoiceLayout.buttonWidth)
        .overlay(
                  RoundedRectangle(cornerRadius: 10)
                      .stroke(.black, lineWidth: 1))
    }
    
    func guess()->Void {
        withAnimation(.guess) {
            game.guessIsValidWord = checker.isAWord(game.guess.word.lowercased())
            game.attemptGuess()
            selection = 0
        }
    }
    
    var eraseButton: some View {
        Button("⌫") {erase()}
            .foregroundStyle(.black)
            .frame(width: 1.3*ChoiceLayout.buttonWidth, height: ChoiceLayout.buttonWidth)
            .overlay(
                      RoundedRectangle(cornerRadius: 10)
                          .stroke(.black, lineWidth: 1))
    }
    
    func erase()->Void {
        selection = max(0,selection - 1)
        //TODO: reduce coupling here:
        game.setGuessPeg(CharSeq.missing, at: selection)
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

#Preview {
    WordBreakerView()
}
