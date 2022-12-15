//
//  HomeRunView.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import SwiftUI

extension HomeView {
  func homeRunView() -> some View {
    return VStack(alignment: .leading) {
      
      VStack(alignment: .leading){
        Text("Your Running Mix")
          .font(.custom("HelveticaNeue-Bold", fixedSize: 24))
        
        Text("The playlists we use to match your current vibe")
          .font(.custom("HelveticaNeue", fixedSize: 15))
        
        PlaylistPreviewView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
          .disabled(!spotify.isAuthorized)
          .frame(height: 50)
					.padding(.all, 20)
				Text("\(selectedPlaylists.count) playlists selected")
				
				if(selectedPlaylists.count > 0){
					HStack{
						ForEach(0..<selectedPlaylists.count, id: \.self){ i in
							if(selectedPlaylists[i].images.count > 1){
								AsyncImage(url: selectedPlaylists[i].images[2].url)
							}
						}
					}
				}
			}
			
			
      

      Spacer().frame(maxHeight: 64)
  
      
      Text("The Vibe")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
			
			Text("\(vibe)")
					.font(Font.system(size: 46, weight: .bold))
					.multilineTextAlignment(.center)
					.foregroundStyle(

							LinearGradient(
									colors: [.red, .blue, .green, .yellow],
									startPoint: .leading,
									endPoint: .trailing
							)
					)
			
			
			Picker("What is your vibe?", selection: $vibe) {
					ForEach(["Chill", "Casual", "Determined", "HYPR"], id: \.self) {
							Text($0)
					}
			}
			.pickerStyle(.segmented)

      Spacer().frame(maxHeight: 148)
      
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
        List {
          ForEach(self.runViewModel.runs, id: \.self) { run in
            NavigationLink(
              destination: RunDetailView(run: run),
              label: {
                HStack {
                  Text(FormatDisplay.date(run.timestamp))
                    .fontWeight(.bold)
                  Spacer()
                  Text(FormatDisplay.distance(run.distance))
                }
            })
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
    }
    .onAppear(perform: self.runViewModel.retrieveRuns)
  }
}
