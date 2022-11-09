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
	
	@ObservedObject var spotify: Spotify
	let dispatchGroup = DispatchGroup()
	@State var cancellables: Set<AnyCancellable> = []


	
	@State var secondsLeft = 4
	@State var isPlaying : Bool = false
	@State var isRunning : Bool = false
	
	@State var pTracks : [PlaylistItem] = []
	
	@State private var alert: AlertItem? = nil
	
	@Binding var selectedPlaylists: [String]
	@Binding var playlists: [Playlist<PlaylistItemsReference>]
	@Binding var tracks: [PlaylistItem]
	
	init(spotify: Spotify, playlists: Binding<[Playlist<PlaylistItemsReference>]>, selectedPlaylists: Binding<[String]>, tracks: Binding<[PlaylistItem]>){
		self.spotify = spotify
		self._playlists = playlists
		self._selectedPlaylists = selectedPlaylists
		self._tracks = tracks
	}
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		
		
		VStack{
			
			//MusicBar
			HStack(spacing: 20){
				Image(systemName: "photo.fill")
					.resizable()
					.frame(width: 40, height: 40, alignment: .leading)
				
					.foregroundColor(Color(.white))
					.padding(.top, 10)
				VStack(alignment: .leading){
					Text("Song Name").foregroundColor(Color.white)
					Text("Song Artist").foregroundColor(Color.white)
				}
				.frame(alignment: .center)
				.padding(.bottom, 60)
			}
			.frame(maxWidth: .infinity)
			.background(Color.black)
			
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
			Text("You have selected \(selectedPlaylists.count) playlists")
			Text("You have \(playlists.count) total playlists")
			
			Text("You have \(tracks.count) total tracks")
			
			ForEach(
				Array(tracks.enumerated()),
				id: \.offset
			) { track in
				Text("\(track.element.name)")
			}
			
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
			
			
			Spacer()
			
			HStack(spacing: 40){
				endRunButton
				pauseRunButton
			}
			.padding(.bottom, 50)
			
			HStack(spacing: 70){
				Image(systemName: "backward.fill")
					.resizable()
					.frame(width: 40, height: 40)
					.foregroundColor(Color(.white))
					.padding(.top, 10)
				Button(action: {self.isPlaying.toggle()}) {
						Image(systemName: self.isPlaying == true ? "pause.fill" : "play.fill")
						.resizable()
						.frame(width: 40, height: 40)
						.padding(.top, 10)
						.foregroundColor(Color(.white))
				}
				Image(systemName: "forward.fill")
					.resizable()
					.frame(width: 40, height: 40)
					.padding(.top, 10)
					.foregroundColor(Color(.white))
			}
			.frame(maxWidth: .infinity)
			.background(Color.black)
			.onAppear(perform: retrieveTracks)
		}
		.frame(maxWidth: .infinity)
	}
	
	var endRunButton: some View {
		Button(action: {isRunning = true}, label: {
				Text("END RUN").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
					.foregroundColor(.white)
							.padding(7)
							.frame(width: 150, height: 50)
							.background(
								Color(red: 290, green: 0, blue: 0)
							)
							.cornerRadius(20)
							.shadow(radius: 5)
			})
	}
	
	var pauseRunButton: some View {
		Button(action: {isRunning = true}, label: {
				Text("PAUSE RUN").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
					.foregroundColor(.white)
							.padding(7)
							.frame(width: 150, height: 50)
							.background(
								Color.orange
							)
							.cornerRadius(20)
							.shadow(radius: 5)
			})
	}
	
	func retrieveTracks() {
		//retrievePlaylists()
		self.tracks = []
		print("\(playlists.count)")
		for playlist in playlists {
			let pURI = playlist.uri
			spotify.api.playlist(pURI, market: "US")
				.sink(
					receiveCompletion: { completion in
						print("completion:", completion, terminator: "\n\n\n")
					},
					receiveValue: { playlist in
						
						print("\nReceived Playlist")
						print("------------------------")
						print("name:", playlist.name)
						print("link:", playlist.externalURLs?["spotify"] ?? "nil")
						print("description:", playlist.description ?? "nil")
						print("total tracks:", playlist.items.total)
						
						for track in playlist.items.items.compactMap(\.item) {
							self.tracks.append(track)
						}
					}
				)		.store(in: &cancellables)
		}
		}
	
}
