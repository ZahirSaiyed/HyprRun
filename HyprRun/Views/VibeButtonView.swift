//
//  VibeButtonView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/3/22.
//

import SwiftUI

struct VibeButtonView: View {

		@State private var buttonBackColor:Color = .white

		var body: some View {
				Button(action: {
						
						 switch self.buttonBackColor {
						 case .white:
								 self.buttonBackColor = .blue
						 default:
								 self.buttonBackColor = .white
						 }
				}, label: {Text(".").padding(20).foregroundColor(buttonBackColor)})
//			{
////
////					Text(".").foregroundColor(buttonBackColor)
//				}
				.frame(width: 45, height: 150, alignment: .center)
				.background(buttonBackColor)
		}
}
