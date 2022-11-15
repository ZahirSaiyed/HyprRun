//
//  ContentView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 10/31/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct ContentView: View {
  @StateObject private var viewRouter = ViewRouter()
  @State var root: Route = .homeView
  
  @EnvironmentObject var spotify: Spotify
  @ObservedObject var playerViewModel: PlayerViewModel = PlayerViewModel()
  @ObservedObject var runViewModel: UIRunViewModel = UIRunViewModel()
  
  @State private var selectedPlaylists: [String] = []
  @State private var playlists: [Playlist<PlaylistItemsReference>] = []
  @State private var tracks: [PlaylistItem] = []
  @State private var vibe: Float = 0.0
  @State private var isEditing = false
  
  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  
  @Binding var isAuthorized: Bool
  
  
  var body: some View {
    switch viewRouter.root {
    case Route.splashView:
      SplashView(isAuthorized: $isAuthorized)
      
    case Route.homeView:
      if !self._isAuthorized.wrappedValue {
        SplashView(isAuthorized: $isAuthorized)
      } else {
        HomeView(runViewModel: self.runViewModel, isAuthorized: $isAuthorized, selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks, vibe: $vibe, isEditing: $isEditing).environmentObject(self.viewRouter)
      }
      
    case Route.runView:
      RunView(playerViewModel: self.playerViewModel, runViewModel: self.runViewModel, tracks: $tracks).environmentObject(self.viewRouter)
      
    case Route.postRunView:
      SplashView(isAuthorized: $isAuthorized)
      // Need to change this to be the post-run view
    }
  }
}
