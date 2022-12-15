//
//  PlaylistPreviewView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct PlaylistPreviewView: View {
	
	@EnvironmentObject var spotify: Spotify
	
	@State private var isLoadingPlaylists = false
	@State private var couldntLoadPlaylists = false
	
	@State private var alert: AlertItem? = nil
	@State private var cancellables: Set<AnyCancellable> = []


	//@Binding var selectedPlaylists: [String]
	@Binding var selectedPlaylists: [Playlist<PlaylistItemsReference>]
	@Binding var playlists: [Playlist<PlaylistItemsReference>]
	@Binding var tracks: [PlaylistItem]
		
		var body: some View {
				List {
						NavigationLink(
							"Select Your Playlists", destination: PlaylistListView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
						)
						.font(.custom("HelveticaNeue-Bold", fixedSize: 20))
				}
				.listStyle(PlainListStyle())
				.onAppear(perform: retrievePlaylists)
		}
	
	func retrievePlaylists() {
		self.isLoadingPlaylists = true
		self.playlists = []
		spotify.api.currentUserPlaylists(limit: 50)
			// Gets all pages of playlists.
			.extendPages(spotify.api)
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { completion in
				self.isLoadingPlaylists = false
				switch completion {
				case .finished:
					self.couldntLoadPlaylists = false
				case .failure(let error):
					self.couldntLoadPlaylists = true
					self.alert = AlertItem(
						title: "Couldn't Retrieve Playlists",
						message: error.localizedDescription
					)
				}
			},
				// We will receive a value for each page of playlists. You could
				// use Combine's `collect()` operator to wait until all of the
				// pages have been retrieved.
				receiveValue: { playlistsPage in
						let playlists = playlistsPage.items
						self.playlists.append(contentsOf: playlists)
				}
			)
			.store(in: &cancellables)
	}
}



