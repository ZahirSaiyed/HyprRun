//
//  UserViewModel.swift
//  HyprRun
//
//  Created by Katie Lin on 11/14/22.
//

import Foundation
import SwiftUI
import Combine

class PlayerViewModel: ObservableObject {
  @Published var isPlaying: Bool = false
  @Published var vibe: Double = 0.0
  
  @Published var selectedPlaylists: [String] = []
  @Published var playlists: [Playlist<PlaylistItemsReference>] = []
  @Published var tracks: [PlaylistItem] = []
  
  @Published var songDuration = 0
  @Published var currSong = 0
  
  func playButton() {
    
  }
  
  func playTrack() {
    
  }
  
  func pauseTrack() {
    
  }
  
  func resumeTrack() {
    
  }
}


//  @State var pTracks: [PlaylistItems] = []
//
//  @State private var alert: AlertItem? = nil
//  @State private var playTrackCancellable: AnyCancellable? = nil
