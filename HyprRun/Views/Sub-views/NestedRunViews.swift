//
//  NestedRunViews.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import SwiftUI

extension RunView {
  // MARK: - Partial views
  func playerView() -> some View {
    return HStack(spacing: 20) {
      VStack(alignment: .leading) {
          Text("\(self.currSongName)").foregroundColor(Color.white)
          Text("\(self.currArtist)").foregroundColor(Color.white)
          Text("\(elapsedTimeAsString())").foregroundColor(Color.white)
					Text("\(getPrediction())").foregroundColor(Color.white)
          AsyncImage(url: self.currImageURL)
      }
      .onReceive(timerSong) { input in
        if self.isPlaying {
          self.counter = self.counter + 1
          if(self.counter >= self.currTrackLength){
            self.counter = 0
            nextSong()
          }
        }
      }
      .frame(alignment: .center)
      .padding(.bottom, 60)
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
  }
  
  func progressView() -> some View {
    return VStack {
      Text("Time: \(self.runViewModel.timeLabel)").font(.title2)
      Spacer()
      Text("Distance: \(self.runViewModel.distanceLabel)").font(.title3)
      Text("Pace: \(self.runViewModel.paceLabel)").font(.title3)
      Spacer()
      HStack(spacing: 40) {
        endRunButton
        if self.runViewModel.currentState == .running {
          pauseRunButton
        } else {
          resumeRunButton
        }
      }
      .padding(.bottom, 50)
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
  }
  
  // MARK: - Button components
  var endRunButton: some View {
    Button(action: {
          self.runViewModel.endRun()
          self.runViewModel.saveRun()
          // Need an if statement or something - should have a binding variable that checks if the user confirms to end run -> if they do confirm, then we redirect route from the view to the post-run view
          self.viewRouter.setRoute(.postRunView)
        }, label: {
          Text("END RUN").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
            .foregroundColor(.white)
            .padding(7)
            .frame(width: 150, height: 50)
            .background(Color(red: 290, green: 0, blue: 0))
            .cornerRadius(20)
            .shadow(radius: 5)
        })
  }
  
  var pauseRunButton: some View {
    Button(action: {
      self.runViewModel.pauseRun()
    }, label: {
      Text("PAUSE RUN").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
        .foregroundColor(.white)
        .padding(7)
        .frame(width: 150, height: 50)
        .background(Color.orange)
        .cornerRadius(20)
        .shadow(radius: 5)
    })
  }
  
  var resumeRunButton: some View {
    Button(action: {
      self.runViewModel.resumeRun()
    }, label: {
      Text("RESUME RUN").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
        .foregroundColor(.white)
        .padding(7)
        .frame(width: 150, height: 50)
        .background(Color.green)
        .cornerRadius(20)
        .shadow(radius: 5)
    })
  }
}
