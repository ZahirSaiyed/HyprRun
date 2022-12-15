//
//  NestedRunViews.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import SwiftUI
import MapKit

extension RunView {
  // MARK: - Partial views
  func playerView() -> some View {
    return HStack(spacing: 20) {
      VStack(alignment: .leading) {
          Text("SONG INFO LOADING...")
        
          Text("\(self.currSongName)")
            .foregroundColor(Color.white)
            .font(.custom("HelveticaNeue-Medium", fixedSize: 14))
            .padding(.top, 10)
        
          Text("\(self.currArtist)")
            .foregroundColor(Color.gray)
            .font(.custom("HelveticaNeue-Medium", fixedSize: 12))
            
          Spacer().frame(maxHeight: 5)
          
          Text("\(elapsedTimeAsString())")
            .foregroundColor(Color.white)
        
          Spacer().frame(maxHeight: 10)
  
          AsyncImage(url: self.currImageURL)
            .scaledToFit()
      }
      .frame(alignment: .center)
      .onReceive(timerSong) { input in
        if self.isPlaying {
          self.counter = self.counter + 1
          if(self.counter >= self.currTrackLength){
            self.counter = 0
            nextSong()
          }
        }
      }
      
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
  }
  
  func progressView() -> some View {
    return VStack {
      Spacer()
      
      VStack(spacing: 10){
        MetricLabel(metric: "Time", val: "\(self.runViewModel.timeLabel)")
        
        MetricLabel(metric: "Distance", val: "\(self.runViewModel.distanceLabel)")
        
        MetricLabel(metric: "Pace", val: "\(self.runViewModel.paceLabel)")
      }
      .padding([.trailing, .leading], 45)
      
      Spacer()
      
      HStack(spacing: 30) {
        endRunButton
        if self.runViewModel.currentState == .running {
          pauseRunButton
        } else {
          resumeRunButton
        }
      }
      
      Spacer()
			
			Picker("What is your vibe?", selection: $vibe) {
					ForEach(["Chill", "Light", "Determined", "HYPR"], id: \.self) {
							Text($0)
					}
			}
			.pickerStyle(.segmented)

    }
  }
  
  func controlsBar() -> some View {
    return HStack(spacing: 70) {
      Button(action: prevSong) {
        Image(systemName: "backward.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundColor(Color.white)
          .padding(.top, 10)
      }
      Button(action: playButton) {
        Image(systemName: self.isPlaying == true ? "pause.fill" : "play.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundColor(Color.white)
          .padding(.top, 10)
      }
      Button(action: nextSong) {
        Image(systemName: "forward.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundColor(Color.white)
          .padding(.top, 10)
      }
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
		.onAppear(perform: retrieveTracks)
		.task(id: self.tracks){
			retrieveFeatures(items: self.tracks)
			retrievePredictions(items: self.tracks)
		}
  }
	
	func mapView() -> some View{
		Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
								.frame(width: 500, height: 400)
	}
  
  // MARK: - Button components
  var endRunButton: some View {
    Button(action: {
      self.runViewModel.endRun() // Note: Just calling 'endRun()' here because that method calls 'saveRun()' for us. This prevents us from creating a duplicate object.
      // TODO: Need to add an if statement or something - should have a binding variable that checks if the user confirms to end run -> if they do confirm, then we redirect route from the view to the post-run view
      self.viewRouter.setRoute(.postRunView)
    }, label: {
      Text("END RUN")
    })
    .accessibility(identifier: "Resume Run")
    .buttonStyle(RunControlButton(
      color: Color(red: 290, green: 0, blue: 0),
      width: 125)
    )
  }
  
  var pauseRunButton: some View {
    Button(action: {
      self.runViewModel.pauseRun()
    }, label: {
      Text("PAUSE RUN")
    })
    .accessibility(identifier: "Resume Run")
    .buttonStyle(RunControlButton(color: Color.orange, width: 220))
  }
  
  var resumeRunButton: some View {
    Button(action: {
      self.runViewModel.resumeRun()
    }, label: {
      Text("RESUME RUN")
    })
    .accessibility(identifier: "Resume Run")
    .buttonStyle(RunControlButton(color: Color.green, width: 220))

  }
}
