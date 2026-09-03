//
//  PegChooserView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import SwiftUI

struct PegChooserView<LeftExtraButton:View, RightExtraButton:View>: View {
    //MARK: Data In
    let choices:[Peg]
    let bestSoFars: [Peg:ChoiceBestSoFar]
    @ViewBuilder let leftExtraButton: () -> LeftExtraButton
    @ViewBuilder let rightExtraButton: () -> RightExtraButton
    //MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    init(choices: [Peg],
         bestSoFars: [Peg : ChoiceBestSoFar],
         onChoose: ((Peg) -> Void)? = nil,
        @ViewBuilder leftExtraButton: @escaping () -> LeftExtraButton = { EmptyView() },
        @ViewBuilder rightExtraButton: @escaping () -> RightExtraButton = { EmptyView() }
    ) {
        self.choices = choices
        self.bestSoFars = bestSoFars
        self.onChoose = onChoose
        self.leftExtraButton = leftExtraButton
        self.rightExtraButton = rightExtraButton
    }
    
    
    //MARK: - Body
    
    var body: some View {
        //TODO: make number of keys in a row dependent on geometry(eg landscape vs portrait)
        let choicesRows:[[Peg]] = chunk(choices, by: ChoiceLayout.choicesPerRow)
        
        VStack {
            ForEach(choicesRows, id: \.self) { row in
                HStack {
                    let isLastRow = (row.count == ChoiceLayout.choicesPerRow.last!)
                    if isLastRow {
                        leftExtraButton()
                    }
                    ForEach(row, id: \.self) { peg in
                        //TODO: keep sizing the same
                        Button {
                            onChoose?(peg)
                        } label: {
                            CharView(peg:peg)
                        }
                        .frame(width: ChoiceLayout.buttonWidth, height: ChoiceLayout.buttonWidth)
                        .foregroundStyle(matchOverlayColor(for: bestSoFars[peg] ?? .notUsedYet))
                    }
                    if isLastRow {
                        rightExtraButton()
                    }
                }
                .frame(width:CGFloat(row.count+1)*(ChoiceLayout.buttonWidth+ChoiceLayout.spacing))
            }
            //.background(Color.red.opacity(0.5))
        }
    }
    
    func matchOverlayColor(for bestSoFar:ChoiceBestSoFar) -> Color {
        switch bestSoFar {
            case .exact   : .green
            case .inexact : .blue
            case .noMatch : .red
            case .notUsedYet : .black
        }
    }    
}

struct ChoiceLayout {
    static let choicesPerRow: [Int] = [10,9,7]
    static let spacing: CGFloat = 5
    static let buttonWidth : CGFloat = 30
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
    PegChooserView(choices:pegChoices,
                   bestSoFars: ["A":.notUsedYet,"B":.exact,"C":.noMatch,"D":.inexact],
                   onChoose: nil)
}
