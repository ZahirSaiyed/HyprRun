//
//  SelectButtonView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI

struct SelectBoxView: View {
		@Binding var selected: Bool
		@Binding var selectedPlaylists: [String]

		@State var name: String
	
	init(selected: Binding<Bool> , selectedPlaylists: Binding<[String]>, name: String) {
		self._selected = selected
		self._selectedPlaylists = selectedPlaylists
		self.name = name
	}

	
		var body: some View {
				Image(systemName: selected ? "checkmark.square.fill" : "square")
						.foregroundColor(selected ? Color(UIColor.systemBlue) : Color.secondary)
						.onTapGesture {
								self.selected.toggle()
							if(self.selected){
								self.selectedPlaylists.append(self.name)
								self.selectedPlaylists = self.selectedPlaylists.removingDuplicates()
							}
							else {
								self.selectedPlaylists.removeAll { playList in
									playList == self.name
								}
							}
						}
		}
}

