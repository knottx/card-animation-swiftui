//
//  ContentView.swift
//  CardAnimation
//
//  Created by Visarut Tippun on 30/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var expandCards: Bool = false
    @State private var currentCard: Song?
    @State private var currentCardIndex: Int = -1
    @State private var showDetail: Bool = false
    
    @Namespace private var animation
    
    @State private var cardSize: CGSize = .zero
    
    @State private var animateDetailView: Bool = false
    @State private var rotateCards: Bool = false
    @State private var showDetailContent: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    //
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title2)
                }
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
            } //: HStack
            .overlay {
                Text("My Playlist")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .foregroundColor(.black)
            
            GeometryReader { proxy in
                let size = proxy.size
                StackPlayerView(size: size)
                    .frame(width: size.width, height: size.height, alignment: .center)
            } //: GeometryReader
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Recently Played")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(playlist) { song in
                            Image(song.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 96, height: 96)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                )
                        } //: ForEach
                    } //: HStack
                    .padding([.horizontal, .bottom])
                } //: ScrollView
            } //: VStack
        } //: VStack
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.colorBG
                .ignoresSafeArea()
        )
        .overlay {
            if let currentCard = currentCard, showDetail {
                ZStack {
                    Color.colorBG
                        .ignoresSafeArea()
                    DetailView(currentCard: currentCard)
                } //: ZStack
            }
        }
    }
    
    @ViewBuilder
    func StackPlayerView(size: CGSize) -> some View {
        let offsetHeight = size.height * 0.1
        
        ZStack {
            ForEach(songCards.reversed()) { song in
                
                let index = songCards.firstIndex(where: { $0.id == song.id }) ?? 0
                let imageSize = size.width - (CGFloat(index) * 20)
                
                Image(song.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize / 2, height: imageSize / 2)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                    .rotation3DEffect(.init(degrees: expandCards && currentCardIndex != index ? -10 : 0),
                                      axis: (x: 1, y: 0, z: 0),
                                      anchor: .center,
                                      anchorZ: 1, perspective: 1)
                    .rotation3DEffect(.init(degrees: showDetail && currentCardIndex == index  && rotateCards ? 360 : 0),
                                      axis: (x: 1, y: 0, z: 0),
                                      anchor: .center,
                                      anchorZ: 1, perspective: 1)
                    .matchedGeometryEffect(id: song.id, in: animation)
                    .offset(y: CGFloat(index) * -20)
                    .offset(y: expandCards ? -CGFloat(index) * offsetHeight : 0)
                    .onTapGesture {
                        if expandCards {
                            withAnimation(.interactiveSpring(response: 0.7,
                                                             dampingFraction: 0.8,
                                                             blendDuration: 0.8)) {
                                cardSize = .init(width: imageSize / 2, height: imageSize / 2)
                                currentCard = song
                                currentCardIndex = index
                                showDetail = true
                                rotateCards = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring()) {
                                        animateDetailView = true
                                    }
                                }
                            }
                        } else {
                            withAnimation(.interactiveSpring(response: 0.6,
                                                             dampingFraction: 0.7,
                                                             blendDuration: 0.7)) {
                                expandCards = true
                            }
                        }
                    }
                    .offset(y: showDetail && currentCardIndex != index ?
                            size.height * (currentCardIndex < index ? -1 : 1) : 0)
            } //: ForEach
        } //: ZStack
        .offset(y: expandCards ? offsetHeight * 2: 0)
        .frame(width: size.width, height: size.height)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7,
                                             blendDuration: 0.7)) {
                expandCards.toggle()
            }
        }
    }
    
    @ViewBuilder
    func DetailView(currentCard: Song) -> some View {
        VStack(spacing: 0) {
            Button {
                rotateCards = false
                withAnimation {
                    showDetailContent = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.interactiveSpring(response: 0.7,
                                                     dampingFraction: 0.8,
                                                     blendDuration: 0.8)) {
                        self.currentCardIndex = -1
                        self.currentCard = nil
                        showDetail = false
                        animateDetailView = false
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    Image(currentCard.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                        )
                        .rotation3DEffect(.init(degrees: showDetail && rotateCards ? -180 : 0),
                                          axis: (x: 1, y: 0, z: 0),
                                          anchor: .center,
                                          anchorZ: 1,
                                          perspective: 1)
                        .rotation3DEffect(.init(degrees: animateDetailView && rotateCards ? 180 : 0),
                                          axis: (x: 1, y: 0, z: 0),
                                          anchor: .center,
                                          anchorZ: 1,
                                          perspective: 1)
                        .matchedGeometryEffect(id: currentCard.id, in: animation)
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        VStack {
                            Text(currentCard.name)
                                .font(.title2.bold())
                                
                            Text(currentCard.artist)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.top, 10)
                        
                        HStack(spacing: 50) {
                            Button {
                                //
                            } label: {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                            }

                            Button {
                                //
                            } label: {
                                Image(systemName: "pause.fill")
                                    .font(.title2)
                                    .frame(width: 55, height: 55)
                                    .background {
                                        Circle()
                                            .fill(Color.colorRed)
                                    }
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                //
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.title2)
                            }
                        } //: HStack
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        
                        Text("Upcoming Song")
                            .font(.title3.bold())
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(playlist) { song in
                            if song.id != currentCard.id {
                                SongCardView(song: song)
                            }
                        }
                    } //: VStack
                    .foregroundColor(.black)
                    .offset(y: showDetailContent ? 0 : 300)
                    .opacity(showDetailContent ? 1 : 0)
                    .padding(.horizontal)
                } //: VStack
                .frame(maxWidth: .infinity)
            } //: ScrollView
        } //: VStack
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut) {
                    showDetailContent = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
