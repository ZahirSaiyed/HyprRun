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
          .font(.custom("HelveticaNeue-Bold", fixedSize: 36))
          .foregroundStyle(hyprGreen)
          .padding(.bottom, 4)
        
        Text("The playlists we use to match your current vibe")
          .font(.custom("HelveticaNeue", fixedSize: 15))
          .padding(.bottom, 12)
        
        PlaylistPreviewView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
          .disabled(!spotify.isAuthorized)
          .frame(height: 50)
          
        
				Text("\(selectedPlaylists.count) playlists selected")
          .padding(.bottom, 25)
          .foregroundStyle(Color.gray)
          
				
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
      
//      HStack {
//        Slider(
//          value: $vibe,
//          in: 0...5,
//          step: 1.0,
//          onEditingChanged: { editing in
//            isEditing = editing
//          })
//        Text("\(vibe)")
//          .foregroundColor(isEditing ? .red : .blue)
//      }
//      .frame(alignment: .center)
      
      Text("The Vibe")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
			
			Text("\(vibe)")
					.font(Font.system(size: 46, weight: .bold))
					.multilineTextAlignment(.center)
					.foregroundStyle(

							LinearGradient(
                colors: [.red, .blue, hyprGreen, .yellow],
									startPoint: .leading,
									endPoint: .trailing
							)
					)
			
			
			Picker("What is your vibe?", selection: $vibe) {
					ForEach(["Chill", "Light", "Determined", "HYPR"], id: \.self) {
							Text($0)
					}
			}
			.pickerStyle(.segmented)

      Spacer()
      newRunButton.offset(x: 50, y: 0)
      Spacer()
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
