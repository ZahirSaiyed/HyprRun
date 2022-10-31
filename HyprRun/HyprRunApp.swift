//
//  HyprRunApp.swift
//  HyprRun
//
//  Created by Katie Lin, Emily Ngo, and Zahir Saiyed on 10/31/22.
//

import Combine
import SpotifyWebAPI
import SwiftUI

@main
struct HyprRunApp: App {
	
		@StateObject var spotify = Spotify()
	
	init() {
			SpotifyAPILogHandler.bootstrap()
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
						.environmentObject(spotify)
        }
    }
}
