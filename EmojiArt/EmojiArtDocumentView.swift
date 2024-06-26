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
    
    private let palleteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack {
            documentBody
            
            PaletteChooser()
                .font(.system(size: palleteEmojiSize))
                .padding(.horizontal)
        }
        
    }
    private var documentBody: some View {
        GeometryReader { geometry in 
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
               
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    @State var zoom: CGFloat = 1
    @State var pan: CGOffset = .zero
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { motionScale, gestureZoom, _ in gestureZoom = motionScale }
            .onEnded { endingPinchScale in zoom *= endingPinchScale }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in gesturePan = value.translation }
            .onEnded { value in pan += value.translation }
    }
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background) { phase in
            if let image = phase.image {
                image
            } else if let url = document.background {
                if phase.error != nil {
                    Text("\(url)")
                } else {
                    ProgressView()
                }
            }
        }
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(emoji, at: emojiPosition(at: location, in: geometry), size: palleteEmojiSize)
                return true
            default:
                break
            }
        }
        return false
    }
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int((location.x - center.x - pan.width) / zoom),
                              y: Int(-(location.y - center.y - pan.height) / zoom))
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
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
//
