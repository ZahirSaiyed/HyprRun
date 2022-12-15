//
//  ContentView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 10/31/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI
import CoreML

struct ContentView: View {
  @StateObject private var viewRouter = ViewRouter()
  @State var root: Route = .homeView
  
  @EnvironmentObject var spotify: Spotify	
  @ObservedObject var runViewModel: UIRunViewModel = UIRunViewModel()
	
	@State private var selectedPlaylists: [Playlist<PlaylistItemsReference>] = []
  @State private var playlists: [Playlist<PlaylistItemsReference>] = []
  @State private var tracks: [PlaylistItem] = []
//	@State private var features: [MusicRunningInput] = []
	@State private var features: [RandForestInput] = []
	@State private var predictions: [String] = []
//	@State private var vibe: Float = 0.0
	@State private var vibe: String = "Chill"
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
        HomeView(runViewModel: self.runViewModel, runViewToggled: $viewRouter.runViewToggled, isAuthorized: $isAuthorized, selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks, vibe: $vibe, isEditing: $isEditing).environmentObject(self.viewRouter)
      }
      
    case Route.runView:
			RunView(runViewModel: self.runViewModel, selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks, features: $features, predictions: $predictions, vibe: $vibe).environmentObject(self.viewRouter).preferredColorScheme(.dark)
      
    case Route.postRunView:
      PostRunView(runViewModel: self.runViewModel).environmentObject(self.viewRouter)
      
    }
  }
}
