//
//  PlaylistView.swift
//  HyprRun
//
//  Created by Katie Lin, Emily Ngo, and Zahir Saiyed on 10/31/22.
//  Adapted from Peter Schorn's Example App: https://github.com/Peter-Schorn/SpotifyAPIExampleApp
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct PlaylistsListView: View {
		
		@EnvironmentObject var spotify: Spotify

		@State private var playlists: [Playlist<PlaylistItemsReference>] = []
		
		@State private var cancellables: Set<AnyCancellable> = []
		
		@State private var isLoadingPlaylists = false
		@State private var couldntLoadPlaylists = false
		
		@State private var alert: AlertItem? = nil
	
		//@State private var selectedPlaylists: [String] = []
		@Binding var selectedPlaylists: [String]
	
		init(selectedPlaylists: Binding<[String]>) {
			self._selectedPlaylists = selectedPlaylists
		}
		
		var body: some View {
				VStack {
					if playlists.isEmpty {
						if isLoadingPlaylists {
							HStack {
								ProgressView()
									.padding()
								Text("Loading Playlists")
									.font(.title)
									.foregroundColor(.secondary)
							}
						}
						else if couldntLoadPlaylists {
							Text("Couldn't Load Playlists")
								.font(.title)
								.foregroundColor(.secondary)
						}
						else {
							Text("No Playlists Found")
								.font(.title)
								.foregroundColor(.secondary)
						}
					}
					else {
						List {
							ForEach(playlists, id: \.uri) { playlist in
								PlaylistCellView(spotify: spotify, playlist: playlist, selectedPlaylists: $selectedPlaylists)
							}
							Text("Selected Playlists")
							Text("There are \(selectedPlaylists.count) selected playlists")
						}
						.listStyle(PlainListStyle())
						.accessibility(identifier: "Playlists List View")
					}
				}
				.navigationTitle("Build Your Soundtrack")
				.navigationBarItems(trailing: refreshButton)
				.alert(item: $alert) { alert in
					Alert(title: alert.title, message: alert.message)
				}
				.onAppear(perform: retrievePlaylists)
		}
		
		var refreshButton: some View {
				Button(action: retrievePlaylists) {
						Image(systemName: "arrow.clockwise")
								.font(.title)
								.scaleEffect(0.8)
				}
				.disabled(isLoadingPlaylists)
				
		}
		
		func retrievePlaylists() {
				
				self.isLoadingPlaylists = true
				self.playlists = []
				spotify.api.currentUserPlaylists(limit: 50)
						// Gets all pages of playlists.
						.extendPages(spotify.api)
						.receive(on: RunLoop.main)
						.sink(
								receiveCompletion: { completion in
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

