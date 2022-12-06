//
//  SplashView.swift
//  HyprRun
//
//  Created by Emily on 11/11/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
let hyprBlue = Color(red: 0.13, green: 0.00, blue: 0.95)

struct SplashView: View {
		@EnvironmentObject var spotify: Spotify
		@Binding var isAuthorized: Bool

	
		var body: some View {
			ZStack {
				hyprBlue.ignoresSafeArea() // 1
				VStack {
					Text("HyprRun")
						.font(.system(size: 44))
						.bold()
						.italic()
					
					Spacer().frame(minHeight: 20, maxHeight: 40)
					VStack(spacing: 10){
						Text("💥  you set the vibe")
						Text("🎧  we curate tracks for your run")
						Text("💪  you crush your workout")
					}
					.font(.system(size: 20, weight: .medium, design: .default))
					
					
					Spacer().frame(minHeight: 50, maxHeight: 134)
					
					Text("think of us as the friend you can _always_ trust with the aux.")
						.multilineTextAlignment(.center)
						.font(.system(size: 18, weight: .light, design: .default))
					
					Spacer().frame(minHeight: 50, maxHeight: 77)
					
					if (!self.isAuthorized){
//					if(!spotify.isAuthorized){
							Button(action: authorize) {
//							Button(action: spotify.authorize) {

						HStack {
							Text("Log in with Spotify")
								.font(.title)
						}
						.padding()
						.clipShape(Capsule())
						.shadow(radius: 5)
					}
						.accessibility(identifier: "Log in with Spotify Identifier")
						.buttonStyle(PlainButtonStyle())
					// Prevent the user from trying to login again
					// if a request to retrieve the access and refresh
					// tokens is currently in progress.
						.allowsHitTesting(!spotify.isRetrievingTokens)
						.padding(.bottom, 5)
				}
					
					}.padding(50)
			}
			.foregroundColor(.white)
			.accentColor(Color.white)
		}
	
	func authorize(){
		spotify.authorize()
		self.isAuthorized = true
	}
}
