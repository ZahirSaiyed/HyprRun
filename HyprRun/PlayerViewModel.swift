//
//  UserViewModel.swift
//  HyprRun
//
//  Created by Katie Lin on 11/14/22.
//

import Foundation
import SwiftUI
import SpotifyWebAPI
import Combine

class PlayerViewModel: ObservableObject {
  @Published var isPlaying: Bool = false
  @Published var vibe: Double = 0.0
  
  @Published var selectedPlaylists: [String] = []
  @Published var playlists: [Playlist<PlaylistItemsReference>] = []
  @Published var tracks: [PlaylistItem] = []
  
  @Published var songDuration = 0
  @Published var currSong = 0
  
  func retrieveTracks() {
    
  }
  
  func playButton() {
    
  }
  
  func playTrack() {
    
  }
  
  func pauseTrack() {
    
  }
  
  func resumeTrack() {
    
  }
}


//  @State var isRunning: Bool = false
    // We can reference self.runViewModel.currentState instead (Can we??)
  
//  @State var songDuration = 0
//  @State var currSong = 0
//  @State var pTracks: [PlaylistItems] = []
//
//  @State private var alert: AlertItem? = nil
//  @State private var playTrackCancellable: AnyCancellable? = nil
//
//  @Binding var selectedPlaylists: [String]
//  @Binding var playlists: [Playlist<PlaylistItemsReference>]
//  @Binding var tracks: [PlaylistItem]
//
//  init(spotify: Spotify, playlists: Binding<[Playlist<PlaylistItemsReference>]>, selectedPlaylists: Binding<[String]>, tracks: Binding<[PlaylistItem]>) {
//    self.spotify = spotify
//    self._playlists = playlists
//    self._selectedPlaylists = selectedPlaylists
//    self._tracks = tracks
//  }
