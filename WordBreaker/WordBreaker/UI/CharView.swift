//
//  CharView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/26/26.
//

import SwiftUI

struct CharView: View {
    // MARK: Data In
    var peg:Peg
    
    // MARK: - body
    let pegShape = RoundedRectangle(cornerRadius:10) //Circle() //
    var body: some View {
        pegShape
            .stroke() //otherwise blacks out
            .overlay {
                if peg == CharSeq.missing {
                    pegShape
                        .strokeBorder(Color.gray)
                } else {
                    Text(String(peg))
                        .font(.system(size: 250)) //so that font is not super-tiny
                        .minimumScaleFactor(0.1)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1,contentMode: .fit)
    }
}

#Preview {
    CharView(peg: "a").padding()
}
