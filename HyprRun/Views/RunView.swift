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
  
  let dispatchGroup = DispatchGroup()
  let start = Date()
  
  @State var cancellables: Set<AnyCancellable> = []
  
  @State var secondsLeft = 4
  @State var songDuration = 0
  @State var isPlaying : Bool = false
  @State var isRunning : Bool = false
  @State var currSong = 0
  
  
  @State var pTracks : [PlaylistItem] = []
  
  @State private var alert: AlertItem? = nil
  
  @State private var playTrackCancellable: AnyCancellable? = nil
  
  
  //	@Binding var selectedPlaylists: [String]
  //	@Binding var playlists: [Playlist<PlaylistItemsReference>]
  //	@Binding var tracks: [PlaylistItem]
  
  //  init(runViewModel: UIRunViewModel, playerViewModel: PlayerViewModel, spotify: Spotify, playlists: Binding<[Playlist<PlaylistItemsReference>]>, selectedPlaylists: Binding<[String]>, tracks: Binding<[PlaylistItem]>){
  //    self.runViewModel = runViewModel
  //    self.playerViewModel = playerViewModel
  //		self.spotify = spotify
  //		self._playlists = playlists
  //		self._selectedPlaylists = selectedPlaylists
  //		self._tracks = tracks
  //	}
  
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  
  var body: some View {
    VStack {
      musicBar
      
      if secondsLeft >= 1 {
        countdownView()
      } else {
        progressView()
      }
    }
  }
  
  
      //	func retrieveTracks() {
      //		//retrievePlaylists()
      //		self.tracks = []
      //		print("\(playlists.count)")
      //		for playlist in playlists {
      //			let pURI = playlist.uri
      //			spotify.api.playlist(pURI, market: "US")
      //				.sink(
      //					receiveCompletion: { completion in
      //						print("completion:", completion, terminator: "\n\n\n")
      //					},
      //					receiveValue: { playlist in
      //
      //						print("\nReceived Playlist")
      //						print("------------------------")
      //						print("name:", playlist.name)
      //						print("link:", playlist.externalURLs?["spotify"] ?? "nil")
      //						print("description:", playlist.description ?? "nil")
      //						print("total tracks:", playlist.items.total)
      //
      //						for track in playlist.items.items.compactMap(\.item) {
      //							self.tracks.append(track)
      //						}
      //					}
      //				)		.store(in: &cancellables)
      //		}
      //		}
      //
    
  var musicBar: some View {
    HStack(spacing: 20) {
      VStack(alignment: .leading) {
        let trackArray = Array(self.playerViewModel.tracks.enumerated())
        if (trackArray.count > 0) {
          let trackZero = trackArray[self.currSong]
          Text("\(trackZero.element.name)").foregroundColor(Color.white)
          Text("ARTIST").foregroundColor(Color.white)
          Text("\(elapsedTimeAsString())")
            .foregroundColor(Color.white)
            .onReceive(timer) { input in
              if isPlaying {
                songDuration = songDuration + 1
              }
            }
        }
      }
      .frame(alignment: .center)
      .padding(.bottom, 60)
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
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
  func countdownView() -> some View {
    return VStack{
      if secondsLeft == 4 {
        Text("Ready?")
          .font(.custom("Avenir-Black", fixedSize: 80))
          .foregroundColor(Color(red: 0, green: 0, blue: 290))
          .frame(maxWidth: .infinity)
          .padding(.top, 175)
          .onReceive(timer) { input in
            secondsLeft = secondsLeft - 1
          }
      } else {
        Text("\(secondsLeft)")
          .font(.custom("Avenir-Black", fixedSize: 90))
          .foregroundColor(Color(red: 0, green: 0, blue: 290))
          .frame(maxWidth: .infinity)
          .padding(.top, 175)
          .onReceive(timer) { input in
            secondsLeft = secondsLeft - 1
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
    
  func elapsedTimeAsString() -> String {
    let duration = self.songDuration
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
    if (self.currSong > 0) {
      self.currSong -= 1
    }
    playTrack()
    self.songDuration = 0
  }
  
  func nextSong() {
    self.currSong += 1
    playTrack()
    self.songDuration = 0
  }
  
  func playButton() {
    self.isPlaying.toggle()
    
    if (self.isPlaying && self.playerViewModel.tracks.count > 0) {
      if (self.songDuration > 0) {
        resumeTrack()
      } else {
        playTrack()
      }
    }
  }
  
  func playTrack() {
    
  }
  
  func pauseTrack() {
    
  }
  
  func resumeTrack() {
    
  }
}
