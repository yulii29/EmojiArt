//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Юлия Прищепкина on 25.04.2024.
//

import Foundation

struct EmojiArt {
    var background: URL?
    private (set) var emojis = [Emoji]()
    
    private var uniqieEmojiId = 0
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqieEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqieEmojiId))
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            static let zero = Self(x: 0, y: 0)
        }
    }
}
