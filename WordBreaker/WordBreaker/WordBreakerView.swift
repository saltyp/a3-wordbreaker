//
//  ContentView.swift
//  WordBreaker
//
//  Created by danielringskog on 6/25/26.
//

import SwiftUI

struct WordBreakerView: View {
    
    // MARK: Data Owned By Me
    @State private var game  = WordBreaker(masterWord: "apple")
    @State private var selection : Int = 0

    //MARK: - body
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
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
