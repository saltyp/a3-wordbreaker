//
//  WordView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import SwiftUI

struct CharSeqView: View {
    // MARK: Data In
    let charSeq : CharSeq
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: - Body
    
    var body: some View {
        ForEach(charSeq.pegs.indices, id:\.self) {index in
            CharView(peg:charSeq.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, charSeq.kind == .guess {
                        Selection.shape.foregroundColor(Selection.color)
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(charSeq.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if charSeq.kind == .guess {
                        selection = index
                    }
                }
                .overlay {
                    if let matches = charSeq.matches {
                        Selection.shape.foregroundStyle(matchOverlayColor(for:matches[index])).opacity(0.5)
                    }
                }
        }
    }
    
    struct Selection {
        static let border : CGFloat = 0.5
        static let cornerRadius : CGFloat = 10
        static let color: Color = Color.gray(0.9)
        static let shape = RoundedRectangle(cornerRadius:cornerRadius)
    }
    
    func matchOverlayColor(for match:Match) -> Color {
        switch match {
            case .exact   : .green
            case .inexact : .blue
            case .nomatch : .gray
        }
    }
    
}

#Preview {
    CharSeqView(charSeq: CharSeq(kind: .mastercode(isHidden: true), pegs:["a","p","p","l","e"]), selection: .constant(1))
}
