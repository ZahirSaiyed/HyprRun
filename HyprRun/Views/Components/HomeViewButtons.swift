//
//  HomeViewButtons.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import SwiftUI

extension HomeView {
  var newRunButton: some View {
    Button(action: {
      self.viewRouter.setRoute(.runView)
      self.runViewModel.startRun()
    }, label: {
      Text("New Run")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
        .foregroundColor(.white)
        .padding(7)
        .frame(width: 250, height: 50)
        .background(hyprBlue)
        .cornerRadius(50)
        .shadow(radius: 10)
    })
  }
  
  /// Removes the authorization information for the user.
  var logoutButton: some View {
      // Calling `spotify.api.authorizationManager.deauthorize` will cause
      // `SpotifyAPI.authorizationManagerDidDeauthorize` to emit a signal,
      // which will cause `Spotify.authorizationManagerDidDeauthorize()` to be
      // called.
      Button(action: spotify.api.authorizationManager.deauthorize, label: {
          Text("Logout")
              .foregroundColor(.white)
              .padding(7)
              .background(
                  Color(red: 0.392, green: 0.720, blue: 0.197)
              )
              .cornerRadius(10)
              .shadow(radius: 3)
      }).frame(alignment: .topLeading)
  }
}
