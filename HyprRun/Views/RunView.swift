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
  @EnvironmentObject var spotify: Spotify
  
  @ObservedObject var runViewModel: UIRunViewModel
  
  @State var songDuration = 0
  @State var isPlaying: Bool = false
  @State var currSong = 0
  
  @State var cancellables: Set<AnyCancellable> = []
  @State var pTracks : [PlaylistItem] = []
  
  @State private var alert: AlertItem? = nil
  @State private var playTrackCancellable: AnyCancellable? = nil
  
  let timerSong = Timer.publish(every: 1, on: .main, in: .common)
//	var timer: Timer?

  
  @Binding var selectedPlaylists: [String]
  @Binding var playlists: [Playlist<PlaylistItemsReference>]
  @Binding var tracks: [PlaylistItem]
  
  var body: some View {
    VStack {
      HStack(spacing: 20) {
        VStack(alignment: .leading) {
          let trackArray = Array(self.tracks.enumerated())
          if (trackArray.count > 0) {
            let trackZero = trackArray[self.currSong]
            Text("\(trackZero.element.name)").foregroundColor(Color.white)
						Text("\(trackZero.element.uri ?? "No URI")").foregroundColor(Color.white)
						
						//Text("\(id)").foregroundColor(Color.white).onAppear(perform: getTrack(uri: trackZero.element.uri ?? ""))
//						Text("\(songDuration)")
//              .foregroundColor(Color.white)
//							.onReceive(timerSong){ _ in
//								if self.isPlaying {
//									songDuration += 1
//								}
//							}
          }
        }
				.onReceive(timerSong, perform: { input in
					print("updating")
//					if self.isPlaying {
						self.songDuration = self.songDuration + 1
//					}
				})
        .frame(alignment: .center)
        .padding(.bottom, 60)
      }
      .frame(maxWidth: .infinity)
      .background(Color.black)
      
      progressView()
      
//      if self.runViewModel.secondsLeft >= 1 {
//        countdownView()
//      } else {
//        progressView()
//      }
      controlsBar
    }.frame(maxWidth: .infinity)
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
 // }
  
  //  func countdownView() -> some View {
  //    return VStack{
  //      if self.runViewModel.secondsLeft == 4 {
  //        Text("Ready?")
  //          .font(.custom("Avenir-Black", fixedSize: 80))
  //          .foregroundColor(Color(red: 0, green: 0, blue: 290))
  //          .frame(maxWidth: .infinity)
  //          .padding(.top, 175)
  //          .onReceive(timer) { input in
  //            self.runViewModel.secondsLeft = self.runViewModel.secondsLeft - 1
  //          }
  //      } else {
  //        Text("\(self.runViewModel.secondsLeft)")
  //          .font(.custom("Avenir-Black", fixedSize: 90))
  //          .foregroundColor(Color(red: 0, green: 0, blue: 290))
  //          .frame(maxWidth: .infinity)
  //          .padding(.top, 175)
  //          .onReceive(timer) { input in
  //            self.runViewModel.secondsLeft = self.runViewModel.secondsLeft - 1
  //          }
  //      }
  //    }
  //  }
}



//extension RunView {
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
		retrievePlaybackState()
		print(self.isPlaying)
		print(self.songDuration)
    if (self.isPlaying && self.tracks.count > 0) {
      if (self.songDuration > 0) {
        resumeTrack()
      } else {
        playTrack()
      }
    } else {
      pauseTrack()
    }
  }
	
	func retrievePlaybackState() {
		spotify.api.currentPlayback()
			.sink(
				receiveCompletion: { completion in
			print("completion: ", completion, terminator: "\n\n\n")
		},
		receiveValue: { playBack in
			let milliseconds = playBack?.progressMS ?? -1
			if(milliseconds != -1){
				let seconds = milliseconds/1000
				self.songDuration = seconds
			}
			else{
				self.songDuration = 0
			}
		}
	).store(in: &cancellables)
	}
  
  func retrieveTracks() {
    self.tracks = []
    for playlist in playlists {
      let pURI = playlist.uri
      spotify.api.playlist(pURI, market: "US")
        .sink(
          receiveCompletion: { completion in
            print("completion: ", completion, terminator: "\n\n\n")
          },
          receiveValue: { playlist in
            for track in playlist.items.items.compactMap(\.item) {
              self.tracks.append(track)
            }
          }
        ).store(in: &cancellables)
    }
  }
  
  func playTrack() {
    let trackArray = Array(self.tracks.enumerated())
    let track = trackArray[self.currSong].element
    let alertTitle = "Couldn't play \(track.name)"
    
    guard let trackURI = track.uri else {
      self.alert = AlertItem(
        title: alertTitle,
        message: "Missing data")
      return
    }
    
    let playbackRequest: PlaybackRequest = PlaybackRequest(trackURI)
    
    self.playTrackCancellable = self.spotify.api
      .getAvailableDeviceThenPlay(playbackRequest)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.alert = AlertItem(
            title: alertTitle,
            message: error.localizedDescription)
          print("\(alertTitle): \(error)")
        }
      })
  }
  
  func pauseTrack() {
    let alertTitle = "Couldn't pause song"
    
    self.playTrackCancellable = self.spotify.api.pausePlayback()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.alert = AlertItem(
            title: alertTitle,
            message: error.localizedDescription)
        }
      })
  }
  
  func resumeTrack() {
    let alertTitle = "Couldn't resume song"
    
    self.playTrackCancellable = self.spotify.api.resumePlayback()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.alert = AlertItem(
            title: alertTitle,
            message: error.localizedDescription)
        }
      })
  }
	
	func getTrack(uri: String) {
		spotify.api.track(uri).sink(
			receiveCompletion: { completion in
		 print("completion: ", completion, terminator: "\n\n\n")
	 },
	 receiveValue: { track in
		 print(track.artists)
	 }
 ).store(in: &cancellables)
	}
}
