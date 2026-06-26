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
            HStack {
                ForEach(choices, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        CharView(peg:peg)
                    }
                }
            }
    }
}

#Preview {
    PegChooserView(choices:["a","b","d"], onChoose: nil)
}
