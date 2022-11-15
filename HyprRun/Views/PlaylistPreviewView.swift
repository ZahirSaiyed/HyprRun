//
//  PlaylistPreviewView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI
import SpotifyWebAPI

struct PlaylistPreviewView: View {

	@Binding var selectedPlaylists: [String]
	@Binding var playlists: [Playlist<PlaylistItemsReference>]
	@Binding var tracks: [PlaylistItem]

		
		var body: some View {
				List {
						NavigationLink(
							"Selected Playlists", destination: PlaylistListView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
						)
				}
				.listStyle(PlainListStyle())
		}
}

