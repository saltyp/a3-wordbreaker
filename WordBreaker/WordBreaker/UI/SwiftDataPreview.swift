//
//  SwiftDataPreview.swift
//  WordBreaker
//
//  Created by danielringskog on 9/4/26.
//
// Copied from CS193p 2025 L14
// struct to provide PreviewModifier to provide data container for Previews

import SwiftUI
import SwiftData

/// struct to solve issue of Previews not working with @Models since no container attached to them:
struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: WordBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        // maybe load up some sample data into container.mainContext here...
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    // static var to make this sharable, wiht @MainActor to put it on main thread in addressing async of SwiftDataPreview
    @MainActor static var swiftData : PreviewTrait<Preview.ViewTraits> = .modifier(SwiftDataPreview())
    
}
