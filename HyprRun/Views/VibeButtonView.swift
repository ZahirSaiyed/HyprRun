//
//  VibeButtonView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI

struct VibeButtonView: View {

		@State private var buttonBackColor:Color = .gray

	var body: some View {
		ForEach(0..<5) { val in
			Button(action: {
				
				switch self.buttonBackColor {
				case .gray:
					self.buttonBackColor = Color(red: 0, green: 0, blue: 290)
				default:
					self.buttonBackColor = .gray
				}
			}, label: {Text(".").padding(20).foregroundColor(buttonBackColor)})
			.frame(width: 45, height: 150, alignment: .center)
			.background(buttonBackColor)
		}
	}
}
