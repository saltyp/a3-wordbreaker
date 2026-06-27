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
        let choicesRows:[[Peg]] = chunk(choices, by: ChoiceLayout.choicesPerRow)
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
    static let choicesPerRow: [Int] = [10,9,7]
    static let spacing: CGFloat = 5
    static let buttonWidth : CGFloat = 32

    
}

func chunk(_ fullArray: [Peg], by chunkSizes: [Int]) -> [[Peg]] {
    var arrayArray : [[Peg]] = []
    guard chunkSizes.reduce(0, {$0 + $1}) == fullArray.count else {
        arrayArray.append(fullArray)
        return arrayArray
    }
    var startIndex:Int = 0
    for chunkSize in chunkSizes {
        let endIndex = startIndex + chunkSize
        arrayArray.append(Array(fullArray[startIndex..<endIndex]))
        startIndex = endIndex
    }
    return arrayArray
}

#Preview {
    let pegChoices = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
    PegChooserView(choices:pegChoices, onChoose: nil)
}
