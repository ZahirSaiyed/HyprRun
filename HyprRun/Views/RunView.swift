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
import CoreML

struct RunView: View {
	
  // MARK: - Properties
  @EnvironmentObject var viewRouter: ViewRouter
  @EnvironmentObject var spotify: Spotify
  
  @ObservedObject var runViewModel: UIRunViewModel
	
  @State var songDuration = 0
	@State var counter = 0
  @State var isPlaying: Bool = true
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
	let MLModel = MusicRunning()
	
	@Binding var selectedPlaylists: [Playlist<PlaylistItemsReference>]
  @Binding var playlists: [Playlist<PlaylistItemsReference>]
  @Binding var tracks: [PlaylistItem]
	@Binding var features: [MusicRunningInput]
  
  // MARK: - Main view
  var body: some View {
    VStack {
      playerView()
      progressView()
      controlsBar()
    }.frame(maxWidth: .infinity)
  }

  // MARK: - Helper functions
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
  
  func updateValues(){
    let trackArray = Array(self.tracks.enumerated())
    if (trackArray.count > 0) {
      let trackZero = trackArray[self.currSong]
      self.currSongName = trackZero.element.name
      self.currURI = trackZero.element.uri ?? "No URI"
      getTrack(uri: self.currURI)
    }
  }
  
  
  // MARK: - Player methods
  func prevSong() {
    if (self.currSong > 0) {
      self.currSong -= 1
    }
    playTrack()
		updateValues()
    self.songDuration = 0
		self.counter = 0
  }
  
  func nextSong() {
    self.currSong += 1
		self.currSong = self.currSong % self.tracks.count
    playTrack()
		updateValues()
    self.songDuration = 0
		self.counter = 0
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
	
  
  // MARK: - API calls
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
		if(selectedPlaylists.count == 0){
			selectedPlaylists = playlists
		}
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
        if track.artists != nil {
          self.currArtist = track.artists?[0].name ?? "NULL"
        }
		 
        self.currTrackLength = track.durationMS ?? 0
        self.currTrackLength /= 1000
		 
        if track.album != nil {
          self.currImageURL = track.album?.images?[1].url ?? URL(string: "https://i.scdn.co/image/ab67616d000048517359994525d219f64872d3b1")!
        }
      }
    ).store(in: &cancellables)
	}
	
	func getPrediction(featureSet: MusicRunningInput) -> String{
		//let input = [0.537, 0.558, 11.0, -8.678, 1.0, 0.2630, 0.910000, 0.1020, 0.505, 131.037]
//		let input = MusicRunningInput(danceability: 0.537, energy: 0.558, key: 11.0, loudness: -8.678, mode: 1.0, acousticness: 0.2630, instrumentalness: 0.910000, liveness: 0.1020, valence: 0.505, tempo: 131.037)
//		let prediction = try? MLModel.predict(input)
//		return prediction?.label ?? "None"
		
		//let prediction = MLModel.predict(MusicRunningInput(danceability: 0.537, energy: 0.558, key: 11.0, loudness: -8.678, mode: 1.0, acousticness: 0.2630, instrumentalness: 0.910000, liveness: 0.1020, valence: 0.505, tempo: 131.037))
		//return prediction.label
		
		if let prediction = try? MLModel.prediction(input: featureSet) {
			return(prediction.label)
		} else {
			return("None")
		}
	}
	
	func retrieveFeatures(items : [PlaylistItem]) {
		self.features = []
		if(self.tracks.count > 0){
			for track in self.tracks{
//				let currTrack = self.tracks[self.currSong]
				var trackID =  track.uri ?? "None"
				if trackID != "None"{
					spotify.api.trackAudioFeatures(trackID).sink(
						receiveCompletion: { completion in
							print("completion: ", completion, terminator: "\n\n\n")
						},
						receiveValue: { feature in
							self.features.append(MusicRunningInput(danceability: feature.danceability, energy: feature.energy, key: Double(feature.key), loudness: feature.loudness, mode: Double(feature.mode), acousticness: feature.acousticness, instrumentalness: feature.instrumentalness, liveness: feature.liveness, valence: feature.valence, tempo: feature.tempo))
						}
					).store(in: &cancellables)
				}
			}
		}
	}
	
	func getFeature(trackNum:Int) -> MusicRunningInput{
		if(self.features.count > 0) {
			return self.features[trackNum]
		}
		//random default MusicRunningInput
		return MusicRunningInput(danceability: 0.537, energy: 0.558, key: 11.0, loudness: -8.678, mode: 1.0, acousticness: 0.2630, instrumentalness: 0.910000, liveness: 0.1020, valence: 0.505, tempo: 131.037)
	}
}
