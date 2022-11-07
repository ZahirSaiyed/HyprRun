//
//  PlaylistPreviewView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI

struct PlaylistPreviewView: View {
	
	//@State private var selectedPlaylists: [String] = []
	@Binding var selectedPlaylists: [String]

		
		var body: some View {
				List {
						NavigationLink(
							"Selected Playlists", destination: PlaylistsListView(selectedPlaylists: $selectedPlaylists)
						)
				}
				.listStyle(PlainListStyle())
		}
}

