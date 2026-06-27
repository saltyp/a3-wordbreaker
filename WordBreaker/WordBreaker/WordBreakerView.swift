//
//  ContentView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import SwiftUI

struct WordBreakerView: View {
    
    // MARK: Data Owned By Me
    @State private var game  = WordBreaker(masterWord: "apple", validWords:["apple","house","foody"])
    @State private var selection : Int = 0

    // MARK: - body
    
    
    var body: some View {
        VStack{
            view(for:game.masterCharSeq)
            ScrollView {
                if !game.isOver {
                    view(for:game.guess)
                }
                Divider()
                ForEach(game.attempts.indices.reversed(), id:\.self) {
                    ix in view(for:game.attempts[ix])
                }
            }
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
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
            .minimumScaleFactor(GuessButton.scaleFactor)
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
        static let minFontSize : CGFloat = 5
        static let maxFontSize : CGFloat = 50
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
