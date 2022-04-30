//
//  Song.swift
//  CardAnimation
//
//  Created by Visarut Tippun on 30/4/22.
//

import Foundation

struct Song: Identifiable {
    var id: String = UUID().description
    var name: String
    var artist: String
    var image: String
    var isLiked: Bool = false
}

let playlist: [Song] = [
    Song(name: "One Two Three",
         artist: "Adikara Fardy",
         image: "song3",
         isLiked: true),
    Song(name: "Dancing with my phone",
         artist: "HYBS",
         image: "song1"),
    Song(name: "Maybe We Could Be a Thing",
         artist: "Jesse Barrera, Michael Carreon, Albert Posis",
         image: "song5",
         isLiked: true),
    Song(name: "Have You Ever",
         artist: "mindfreakk",
         image: "song9"),
    Song(name: "Hold On Tight",
         artist: "Jesse Barrera, Albert Posis",
         image: "song4",
         isLiked: true),
    Song(name: "Ring Pop",
         artist: "JAX",
         image: "song2"),
    Song(name: "Lay Lady Lay (with Gemma Hayes)",
         artist: "Magnet, Gemma Hayes",
         image: "song6"),
    Song(name: "Winter Wonderland",
         artist: "Albert Posis",
         image: "song7",
         isLiked: true),
    Song(name: "Country Roads",
         artist: "Peter Hollens",
         image: "song8"),
    Song(name: "BBIBBI",
         artist: "IU",
         image: "song10",
         isLiked: true)
]

let songCards: [Song] = Array(playlist.prefix(4))
