//
//  SongCardView.swift
//  CardAnimation
//
//  Created by Visarut Tippun on 30/4/22.
//

import SwiftUI

struct SongCardView: View {
    
    var song: Song
    
    var body: some View {
        HStack(spacing: 12) {
            Image(song.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.name)
                    .fontWeight(.semibold)
                
                Text(song.artist)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Label {
                    Text("123,456,789")
                } icon: {
                    Image(systemName: "beats.headphones")
                }
                .font(.caption)
                .foregroundColor(.gray)
            } //: VStack
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                //
            } label: {
                Image(systemName: song.isLiked ? "suit.heart.fill" : "")
                    .font(.title3)
                    .foregroundColor(song.isLiked ? .red : .gray)
            }

            Button {
                //
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        } //: HStack
    }
}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView(song: songCards.first!)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
