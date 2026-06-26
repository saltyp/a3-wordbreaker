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
        let choicesRows:[[Peg]] = choices.chunked(into: 9)
        VStack {
            ForEach(choicesRows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { peg in
                        Button {
                            onChoose?(peg)
                        } label: {
                            CharView(peg:peg)
                        }
                    }
                }
            }
        }
    }
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
