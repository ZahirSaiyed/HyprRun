//
//  RunView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI

struct RunView: View {
	
	@State var secondsLeft = 4
	@State var isPlaying : Bool = false
	@State var isRunning : Bool = false
	

	
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
}
