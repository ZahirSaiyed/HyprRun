//
//  ImageName.swift
//  HyprRun
//
//  Taken from Peter Schorn's Example App: https://github.com/Peter-Schorn/SpotifyAPIExampleApp
//  Required to output alerts
//  Created by Katie Lin, Emily Ngo, and Zahir Saiyed on 10/31/22.
//
import Foundation
import SwiftUI

struct AlertItem: Identifiable {
		
		let id = UUID()
		let title: Text
		let message: Text
		
		init(title: String, message: String) {
				self.title = Text(title)
				self.message = Text(message)
		}
		
		init(title: Text, message: Text) {
				self.title = title
				self.message = message
		}

}
