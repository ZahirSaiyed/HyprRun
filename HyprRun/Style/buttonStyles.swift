//
//  buttons.swift
//  HyprRun
//
//  Created by Emily on 12/5/22.
//

import Foundation
import SwiftUI



struct LoginButton: ButtonStyle {
    var spotifyLogo: ImageName {
      .spotifyLogoBlack
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
          Spacer()
          Image(spotifyLogo)
              .interpolation(.high)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 40)
          configuration.label
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .medium, design: .default))
          Spacer()
        }
          .padding()
          .background(Color.white.cornerRadius(8))

          .foregroundColor(.black)
          .clipShape(Capsule())
    }
}

struct RunControlButton: ButtonStyle {
  var color : SwiftUI.Color;
  var width : CGFloat;
  
  init(color: SwiftUI.Color = Color.gray, width: CGFloat = 150) {
    self.color = color
    self.width = width
  }
    
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.custom("HelveticaNeue-Bold", fixedSize: 18))
      .foregroundColor(.white)
      .padding(7)
      .frame(width: self.width, height: 50)
      .background(self.color)
      .cornerRadius(20)
      .shadow(radius: 5)

  }
}

