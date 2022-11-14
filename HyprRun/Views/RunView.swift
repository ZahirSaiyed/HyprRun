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
    VStack{
      //Countdown
      if(secondsLeft >= 1){
        if secondsLeft == 4 {
          Text("Ready?")
            .font(.custom("Avenir-Black", fixedSize: 80))
            .foregroundColor(Color(red: 0, green: 0, blue: 290))
            .frame(maxWidth: .infinity)
            .padding(.top, 175)
            .onReceive(timer) { input in
              secondsLeft = secondsLeft - 1
            }
        }
        
        else {
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
      //			Text("You have selected \(selectedPlaylists.count) playlists")
      //			Text("You have \(playlists.count) total playlists")
      //
      //			Text("You have \(tracks.count) total tracks")
      
      
      //			ForEach(
      //				Array(tracks.enumerated()),
      //				id: \.offset
      //			) { track in
      //					Text("\(track.element.name)")
      //			}x
      
      //			let trackArray = Array(tracks.enumerated())
      //			if(trackArray.count > 0){
      //				let trackZero = trackArray[self.currSong]
      //				Text("\(trackZero.element.name)")
      //let trackURI = spotify.api.track(trackZero.element.id!)
      //				Text("\(trackURI)")
      //			}
      
      //			ForEach(
      //					Array(playlists.enumerated()),
      //					id: \.offset
      //			) { playlist in
      //
      //				Text("\(playlist.element.uri)")
      //
      //
      //			}
      //
      //			var pTracks = getTracks()
      //
      //			Text("\(pTracks.count)")
      //			ForEach(pTracks, id:\.id){ track in
      //				Text("\(track.name)")
      //			}
      
      
      //				let tracks = spotify.api.playlistTracks(playlist.element.uri)
      //Text("\(tracks.total)")
      
      //				ForEach(
      //					tracks,
      //					id: \.offset
      //				) { track in
      //					Text("Hello")
      //				}
      //TrackView()
      //				Button(action: playTrack, label: {
      //					Text("\(playlist.element.name)")
      //								.lineLimit(1)
      //								.frame(maxWidth: .infinity, alignment: .leading)
      //								.padding()
      //								.contentShape(Rectangle())
      //				})
      //				.buttonStyle(PlainButtonStyle())
      //					Divider()
      
      
      //			Spacer()
      //
      //			HStack(spacing: 40){
      //				endRunButton
      //				pauseRunButton
      //			}
      //			.padding(.bottom, 50)
      //
      //			HStack(spacing: 70){
      //			Button(action: {prevSong()}) {
      //
      //				Image(systemName: "backward.fill")
      //					.resizable()
      //					.frame(width: 40, height: 40)
      //					.foregroundColor(Color(.white))
      //					.padding(.top, 10)
      //			}
      //
      //				Button(action: playButton) {
      //					Image(systemName: self.isPlaying == true ? "pause.fill" : "play.fill")
      //						.resizable()
      //						.frame(width: 40, height: 40)
      //						.padding(.top, 10)
      //						.foregroundColor(Color(.white))
      //				}
      //
      ////				Button(action: playTrack, label: {
      ////						Text("PLAY BUTTON")
      ////								.lineLimit(1)
      ////								.frame(maxWidth: .infinity, alignment: .leading)
      ////								.padding()
      ////								.contentShape(Rectangle())
      ////				})
      ////				.buttonStyle(PlainButtonStyle())
      //
      //				Button(action: nextSong) {
      //					Image(systemName: "forward.fill")
      //						.resizable()
      //						.frame(width: 40, height: 40)
      //						.padding(.top, 10)
      //						.foregroundColor(Color(.white))
      //				}
      //			}
      //			.frame(maxWidth: .infinity)
      //			.background(Color.black)
      //			.onAppear(perform: retrieveTracks)
      //		}
      //		.frame(maxWidth: .infinity)
      //	}
      
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
      //	func prevSong () {
      //		if(self.currSong > 0){
      //			self.currSong -= 1
      //			playTrack()
      //			self.songDuration = 0
      //		}
      //	}
      //
      //	func nextSong () {
      //		self.currSong += 1
      //		playTrack()
      //		self.songDuration = 0
      //	}
      //
      //	func playButton () {
      //		self.isPlaying.toggle()
      //		if(self.isPlaying && self.tracks.count > 0){
      //			if(self.songDuration > 0){
      //				resumeTrack()
      //			}
      //			else{
      //				playTrack()
      //			}
      //		}
      //
      //		else{
      //			pauseTrack()
      //		}
      //	}
      //
      //	func playTrack() {
      //
      //			let trackArray = Array(tracks.enumerated())
      //		let track = trackArray[self.currSong].element
      //			let alertTitle = "Couldn't play \(track.name)"
      //
      //			guard let trackURI = track.uri else {
      //					self.alert = AlertItem(
      //							title: alertTitle,
      //							message: "Missing data"
      //					)
      //					return
      //			}
      //
      //			let playbackRequest: PlaybackRequest
      //
      ////			if let albumURI = self.album.uri {
      ////					// Play the track in the context of its album. Always prefer
      ////					// providing a context; otherwise, the back and forwards buttons may
      ////					// not work.
      ////					playbackRequest = PlaybackRequest(
      ////							context: .contextURI(albumURI),
      ////							offset: .uri(trackURI)
      ////					)
      ////			}
      ////			else {
      //			playbackRequest = PlaybackRequest(trackURI)
      ////			}
      //
      //			self.playTrackCancellable = self.spotify.api
      //					.getAvailableDeviceThenPlay(playbackRequest)
      //					.receive(on: RunLoop.main)
      //					.sink(receiveCompletion: { completion in
      //							if case .failure(let error) = completion {
      //									self.alert = AlertItem(
      //											title: alertTitle,
      //											message: error.localizedDescription
      //									)
      //									print("\(alertTitle): \(error)")
      //							}
      //					})
      //
      //	}
      //
      //	func pauseTrack () {
      //		let alertTitle = "Couldn't Pause Song"
      //
      //		self.playTrackCancellable =
      //		self.spotify.api.pausePlayback()
      //			.receive(on: RunLoop.main)
      //			.sink(receiveCompletion: { completion in
      //				if case .failure(let error) = completion {
      //					self.alert = AlertItem(
      //						title: alertTitle,
      //						message: error.localizedDescription
      //					)
      //				}
      //			})
      //	}
      //
      //	func resumeTrack () {
      //		let alertTitle = "Couldn't Resume Song"
      //
      //		self.playTrackCancellable =
      //		self.spotify.api.resumePlayback()
      //			.receive(on: RunLoop.main)
      //			.sink(receiveCompletion: { completion in
      //				if case .failure(let error) = completion {
      //					self.alert = AlertItem(
      //						title: alertTitle,
      //						message: error.localizedDescription
      //					)
      //				}
      //			})
      //
      //	}
    }
  }
}

extension RunView {
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
  
  var musicBar: some View {
    HStack(spacing: 20) {
      Image(systemName: "photo.fill")
        .resizable()
        .frame(width: 40, height: 40, alignment: .leading)
        .foregroundColor(Color.white)
        .padding(.top, 10)
      
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
        Text("Song Name").foregroundColor(Color.white)
        Text("Song Artist").foregroundColor(Color.white)
      }
      .frame(maxWidth: .infinity)
      .background(Color.black)
    }
  }
}
