//
//  RunView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI

struct RunView: View {
	
	@State var secondsLeft = 4
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
						.onReceive(timer) { input in
							secondsLeft = secondsLeft - 1
						}
				}
				
				else {
					Text("\(secondsLeft)")
						.font(.custom("Avenir-Black", fixedSize: 90))
						.foregroundColor(Color(red: 0, green: 0, blue: 290))
						.frame(maxWidth: .infinity)
						.onReceive(timer) { input in
							secondsLeft = secondsLeft - 1
						}
				}
			}
		}
		.frame(maxWidth: .infinity)
		
	}
}
