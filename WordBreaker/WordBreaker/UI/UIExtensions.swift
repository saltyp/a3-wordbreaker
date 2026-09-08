//
//  UIExtensions.swift
//  WordBreaker
//
//  Created by danielringskog on 7/8/26.
//

import SwiftUI

extension Animation {
    static let wordBreaker = Animation.easeInOut(duration: 0.5)//default //easeOut(duration: 3)
    static let guess = Animation.wordBreaker
    static let restart = Animation.wordBreaker
    static let selection = Animation.wordBreaker
}

extension AnyTransition {
    @MainActor static let keyboard = AnyTransition.offset(x: 0, y:200)
    static func attempt(_ isOver: Bool)-> AnyTransition {
        return AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge:.top),
            removal: .move(edge:.trailing))
    }
}

extension Color  {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

extension View {
    func newGameButtonStyling(minimum: CGFloat = 3, maximum:CGFloat = 30) -> some View {
        self
          .font(.system(size: maximum))
          .minimumScaleFactor(minimum/maximum)
          .foregroundStyle(.white)
          .padding()
          .background(Color(red: 0, green: 0, blue: 0.5))
          .clipShape(Capsule())
    }
}

