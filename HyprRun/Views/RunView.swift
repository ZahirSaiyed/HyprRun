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
	@State var counter = 0
  @State var isPlaying: Bool = false
  @State var currSong = 0
	@State var currArtist = ""
	@State var currURI = ""
	@State var currSongName = ""
	@State var currTrackLength = 0
	@State var currImageURL = URL(string: "https://i.scdn.co/image/ab67616d000048517359994525d219f64872d3b1")
  
  @State var cancellables: Set<AnyCancellable> = []
  @State var pTracks : [PlaylistItem] = []
  
  @State private var alert: AlertItem? = nil
  @State private var playTrackCancellable: AnyCancellable? = nil
  
	let timerSong = Timer.publish(every: 0.99, on: .main, in: .default).autoconnect()

  
  //@Binding var selectedPlaylists: [String]
	@Binding var selectedPlaylists: [Playlist<PlaylistItemsReference>]
  @Binding var playlists: [Playlist<PlaylistItemsReference>]
  @Binding var tracks: [PlaylistItem]
	
  var body: some View {
    VStack {
      HStack(spacing: 20) {
        VStack(alignment: .leading) {
					  Text("\(self.currSongName)").foregroundColor(Color.white)
						Text("\(self.currArtist)").foregroundColor(Color.white)
						Text("\(elapsedTimeAsString())").foregroundColor(Color.white)
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
      
      progressView()
      
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
}



//extension RunView {
  func elapsedTimeAsString() -> String {
    let duration = self.counter
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
		updateValues()
    self.songDuration = 0
  }
  
  func nextSong() {
    self.currSong += 1
		self.currSong = self.currSong % self.tracks.count
    playTrack()
		updateValues()
    self.songDuration = 0
  }
  
  func playButton() {
		updateValues()
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
    for playlist in selectedPlaylists {
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
		let currSongIndex = self.currSong % trackArray.count
    let track = trackArray[currSongIndex].element
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
		 if let artists = track.artists {
			 self.currArtist = track.artists?[0].name ?? "NULL"
		 }
		 
		 self.currTrackLength = track.durationMS ?? 0
		 self.currTrackLength /= 1000
		 
		 if let imageURL = track.album {
			 self.currImageURL = track.album?.images?[1].url ?? URL(string: "https://i.scdn.co/image/ab67616d000048517359994525d219f64872d3b1")!
		 }
	 }
 ).store(in: &cancellables)
	}
	
	func updateValues(){
		let trackArray = Array(self.tracks.enumerated())
		if (trackArray.count > 0) {
			let trackZero = trackArray[self.currSong]
			self.currSongName = trackZero.element.name
			self.currURI = trackZero.element.uri ?? "No URI"
			getTrack(uri: self.currURI)
		}
	}
}
