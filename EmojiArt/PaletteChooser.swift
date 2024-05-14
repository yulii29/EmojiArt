//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Юлия Прищепкина on 14.05.2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
    }
    var chooser: some View {
        Button {
            withAnimation {
                store.cursorIndex += 1
            }
            
        } label: {
            Image(systemName: "paintpalette")
        }
    }
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
    }
}


