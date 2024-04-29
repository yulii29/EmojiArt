//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Юлия Прищепкина on 25.04.2024.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
    }
}
