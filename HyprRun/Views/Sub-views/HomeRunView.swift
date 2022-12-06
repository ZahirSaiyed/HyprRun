//
//  HomeRunView.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import SwiftUI

extension HomeView {
  func homeRunView() -> some View {
    return VStack(alignment: .leading, spacing: 35) {
      Text("Your Running Mix").font(.custom("HelveticaNeue-Bold", fixedSize: 28))
      
      PlaylistPreviewView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
        .disabled(!spotify.isAuthorized)
        .frame(height: 50)
      
      Text("\(selectedPlaylists.count) playlists selected")
      
      Text("The Vibe")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
      
      HStack {
        Slider(
          value: $vibe,
          in: 0...5,
          step: 1.0,
          onEditingChanged: { editing in
            isEditing = editing
          })
        Text("\(vibe)")
          .foregroundColor(isEditing ? .red : .blue)
      }
      .frame(alignment: .center)
      
      newRunButton.offset(x: 50, y: 0)
    }
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading)
    .padding()
  }
}
