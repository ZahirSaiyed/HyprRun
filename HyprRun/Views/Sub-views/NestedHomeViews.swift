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
  
  func homeRewindView() -> some View {
    return VStack {
      if self.runViewModel.runs.count == 0 {
        Spacer().frame(height: 80)
        Text("This is the rewind page :-). You'll be able to look back at runs you've completed here. For now, try going on your first run!")
        Spacer()
      } else {
        List(self.runViewModel.runs, id: \.self) { run in
          HStack(spacing: 20) {
            Text(run.id!).fontWeight(.bold)
            Text(FormatDisplay.distance(run.distance))
            Text(FormatDisplay.time(Int(run.duration)))
          }
        }
      }
      
      Button {
        self.runViewModel.resetData()
      } label: {
        Text("Reset data (Warning!!)")
          .foregroundColor(.red)
          .fontWeight(.bold)
      }

      
//      ScrollView {
//        HStack {
//          let miles = round(self.runViewModel.runs.map({ $0.distance}).reduce(0, +) * 100)/100.0
//          let count = self.runViewModel.runs.count
//          let avgDist: Double = round((miles / (Double(count))) * 100)/100.0
//          VStack {
//            Text("\(miles)").font(.custom("HelveticaNeue-Bold", fixedSize: 28))
//            Text("mi. ran").font(.custom("HelveticaNeue", fixedSize: 16))
//          }
//          Spacer()
//            .frame(width: 40)
//          VStack(alignment: .leading, spacing: 4) {
//            Text("Runs completed: \(count)")
//            Text("Avg. distance: \(avgDist)")
//          }
//        }
//      }
    }
    .onAppear(perform: self.runViewModel.retrieveRuns)
  }
}
