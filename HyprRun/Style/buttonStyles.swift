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

