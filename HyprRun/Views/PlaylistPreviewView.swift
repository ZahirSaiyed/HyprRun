//
//  PlaylistPreviewView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI

struct PlaylistPreviewView: View {
		
		var body: some View {
				List {
						NavigationLink(
								"Selected Playlists", destination: PlaylistsListView()
						)
				}
				.listStyle(PlainListStyle())
		}
}

