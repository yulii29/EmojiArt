//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Юлия Прищепкина on 25.04.2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "🐞🐒🏀🥣🎂🍯🚗🎨🚀🎡🛶🏖️🌲🔥🍔🛝🧘🏼‍♂️🚘✈️🏠🛋️🛒🎈🧸💸☃️⛈️🍵🏝️🏛️⛺️📺🛍️🪑🚩🏴‍☠️💰🖥️🤸‍♂️🪴🐩💃🥶😍🎃"
    private let palleteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack {
            documentBody
            
            ScrollingEmojis(emojis)
                .font(.system(size: palleteEmojiSize))
                .padding(.horizontal)
        }
        
    }
    private var documentBody: some View {
        GeometryReader { geometry in 
            ZStack {
                Color.white
                AsyncImage(url: document.background)
                    .position(Emoji.Position.zero.in(geometry))
                ForEach(document.emojis) { emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
            }
        }
    }
}


struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) {
                    emoji in Text(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
}
//
