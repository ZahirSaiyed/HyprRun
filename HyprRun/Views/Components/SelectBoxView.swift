//
//  SelectButtonView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI
import SpotifyWebAPI

struct SelectBoxView: View {
  @Binding var selected: Bool
	@Binding var selectedPlaylists: [Playlist<PlaylistItemsReference>]

	@State var playlist: [Playlist<PlaylistItemsReference>] 
	
	init(selected: Binding<Bool> , selectedPlaylists: Binding<[Playlist<PlaylistItemsReference>]>, name: [Playlist<PlaylistItemsReference>]) {
		self._selected = selected
		self._selectedPlaylists = selectedPlaylists
		self.playlist = name
	}

	
  var body: some View {
    Image(systemName: selected ? "checkmark.square.fill" : "square")
      .foregroundColor(selected ? Color(UIColor.systemBlue) : Color.secondary)
      .onTapGesture {
        self.selected.toggle()
        if(self.selected){
					print("Before \(self.selectedPlaylists.count)")
					print("Before \(self.playlist.count)")
					self.selectedPlaylists = Array(self.selectedPlaylists + self.playlist)
					print("After \(self.selectedPlaylists.count)")
					print("After \(self.playlist.count)")

          self.selectedPlaylists = self.selectedPlaylists.removingDuplicates()
        } else {
          self.selectedPlaylists.removeAll { playList in
            playList == self.playlist[0]
          }
        }
      }
  }
}

