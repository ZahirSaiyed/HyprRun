//
//  RunView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI
import SpotifyWebAPI
import Foundation
import Combine

struct RunView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  @ObservedObject var playerViewModel: PlayerViewModel
  @ObservedObject var runViewModel: UIRunViewModel
  @ObservedObject var spotify: Spotify
  
//  let dispatchGroup = DispatchGroup()
//  let start = Date()
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  @State var cancellables: Set<AnyCancellable> = []
  @State var pTracks : [PlaylistItem] = []
  
  @State private var alert: AlertItem? = nil
  @State private var playTrackCancellable: AnyCancellable? = nil
  
  @State var playlists: [Playlist<PlaylistItemsReference>] = []
  @State var tracks: [PlaylistItem] = []
  
  var body: some View {
    VStack {
      HStack(spacing: 20) {
        VStack(alignment: .leading) {
          let trackArray = Array(self.tracks.enumerated())
          if (trackArray.count > 0) {
            let trackZero = trackArray[self.playerViewModel.currSong]
            Text("\(trackZero.element.name)").foregroundColor(Color.white)
            Text("ARTIST").foregroundColor(Color.white)
            Text("\(elapsedTimeAsString())")
              .foregroundColor(Color.white)
              .onReceive(timer) { input in
                if self.playerViewModel.isPlaying {
                  self.playerViewModel.songDuration = self.playerViewModel.songDuration + 1
                }
              }
          }
        }
        .frame(alignment: .center)
        .padding(.bottom, 60)
      }
      .frame(maxWidth: .infinity)
      .background(Color.black)
      
      if self.runViewModel.secondsLeft >= 1 {
        countdownView()
      } else {
        progressView()
      }
      
      controlsBar
    }
  }
  
  func countdownView() -> some View {
    return VStack{
      if self.runViewModel.secondsLeft == 4 {
        Text("Ready?")
          .font(.custom("Avenir-Black", fixedSize: 80))
          .foregroundColor(Color(red: 0, green: 0, blue: 290))
          .frame(maxWidth: .infinity)
          .padding(.top, 175)
          .onReceive(timer) { input in
            self.runViewModel.secondsLeft = self.runViewModel.secondsLeft - 1
          }
      } else {
        Text("\(self.runViewModel.secondsLeft)")
          .font(.custom("Avenir-Black", fixedSize: 90))
          .foregroundColor(Color(red: 0, green: 0, blue: 290))
          .frame(maxWidth: .infinity)
          .padding(.top, 175)
          .onReceive(timer) { input in
            self.runViewModel.secondsLeft = self.runViewModel.secondsLeft - 1
          }
      }
    }
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
  
  var controlsBar: some View {
    HStack(spacing: 70) {
      Button(action: { prevSong() }) {
        Image(systemName: "backward.fill")
          .resizable()
          .frame(width: 40, height: 40)
          .foregroundColor(Color.white)
          .padding(.top, 10)
      }
    }
  }
  
  var endRunButton: some View {
    Button(action: {
          self.runViewModel.endRun()
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



extension RunView {
  func elapsedTimeAsString() -> String {
    let duration = self.playerViewModel.songDuration
    let minutes = (Int)(duration/60)
    var str_minutes = ""
    
    if (minutes < 10) {
      str_minutes = "0" + "\(minutes)"
    } else {
      str_minutes = "\(minutes)"
    }
    
    var str_sec = ""
    let seconds = duration % 60
    if (seconds < 10) {
      str_sec = "0" + "\(seconds)"
    } else {
      str_sec = "\(seconds)"
    }
    
    return str_minutes + ":" + str_sec
  }
  
  func prevSong() {
    if (self.playerViewModel.currSong > 0) {
      self.playerViewModel.currSong -= 1
    }
    self.playerViewModel.playTrack()
    self.playerViewModel.songDuration = 0
  }
  
  func nextSong() {
    self.playerViewModel.currSong += 1
    self.playerViewModel.playTrack()
    self.playerViewModel.songDuration = 0
  }
  
  func playButton() {
    self.playerViewModel.isPlaying.toggle()
    if (self.playerViewModel.isPlaying && self.tracks.count > 0) {
      if (self.playerViewModel.songDuration > 0) {
        self.playerViewModel.resumeTrack()
      } else {
        self.playerViewModel.playTrack()
      }
    } else {
      self.playerViewModel.pauseTrack()
    }
  }
  
//  func retrieveTracks() {
//    var tempTracks: [PlaylistItem] = []
//
//    for playlist in self.$playerViewModel.playlists {
//      let pURI = playlist.uri
//      spotify.api.playlist(pURI, market: "US")
//        .sink(receiveValue: { playlist in
//          for track in playlist.items.items.compactMap(\.item) {
//            self.tempTracks.append(track)
//          }
//        }).store(in: &cancellables)
//    }
//
//    self.$playerViewModel.tracks = tempTracks
//  }
}
