//
//  PegChooserView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import SwiftUI

struct PegChooserView: View {
    //MARK: Data In
    let choices:[Peg]
    //MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    //MARK: - Body
    var body: some View {
        //TODO: make number of keys in a row dependent on geometry(eg landscape vs portrait)
        let choicesRows:[[Peg]] = choices.chunked(into: ChoiceLayout.maxNumChoicesPerRow)
        let rowsCount: CGFloat = CGFloat(choicesRows.count)
            VStack {
                ForEach(choicesRows, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { peg in
                            //TODO: keep sizing the same
                            Button {
                                onChoose?(peg)
                            } label: {
                                CharView(peg:peg)
                            }
                            .frame(width: ChoiceLayout.buttonWidth, height: ChoiceLayout.buttonWidth)
                        }
                    }
                }
            }
            .frame(height: rowsCount * ChoiceLayout.buttonWidth + (rowsCount - 1) * ChoiceLayout.spacing)
    }
}

struct ChoiceLayout {
    static let maxNumChoicesPerRow = 9
    static let spacing: CGFloat = 4
    static let buttonWidth : CGFloat = 35

    
}



extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    let pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0).lowercased() }
    PegChooserView(choices:pegChoices, onChoose: nil)
}
