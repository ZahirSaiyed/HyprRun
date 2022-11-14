//
//  HomeView.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct HomeView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  @EnvironmentObject var spotify: Spotify
  @ObservedObject var runViewModel: UIRunViewModel
  
  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  
  @Binding var isAuthorized: Bool
  
  @State private var selectedPlaylists: [String] = []
  @State private var playlists: [Playlist<PlaylistItemsReference>] = []
  @State private var tracks: [PlaylistItem] = []
  @State private var vibe = 0.0
  @State private var isEditing = false
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 35) {
        logoutButton
        Text("Run").font(.custom("HelveticaNeue-Bold", fixedSize: 48))
        Text("Your Running Mix").font(.custom("HelveticaNeue-Bold", fixedSize: 48))
        
        PlaylistPreviewView(selectedPlaylists: $selectedPlaylists, playlists: $playlists, tracks: $tracks)
          .disabled(!spotify.isAuthorized)
          .frame(height: 50)
        
        Text("\(selectedPlaylists.count) playlists selected")
        
        Text("The Vibe")
          .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
        
        HStack {
          Slider(
            value: $vibe,
            in: 0...5,
            step: 1.0,
            onEditingChanged: { editing in
              isEditing = editing
            })
          Text("\(vibe)")
            .foregroundColor(isEditing ? .red : .blue)
        }.frame(alignment: .center)
        
        newRunButton.offset(x: 50, y: 0)

      }
    }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity,
        alignment: .topLeading)
    .padding()
    .modifier(LoginView())
    // Called when a redirect is received from Spotify
    .onOpenURL(perform: handleURL(_:))
  }
}



extension HomeView {
  var newRunButton: some View {
    Button(action: {
      self.viewRouter.setRoute(.runView)
      self.runViewModel.startRun()
    }, label: {
      Text("NEW RUN")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
        .foregroundColor(.white)
        .padding(7)
        .frame(width: 250, height: 50)
        .background(Color(red: 0, green: 0, blue: 290))
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
  
  /**
   Handle the URL that Spotify redirects to after the user Either authorizes
   or denies authorization for the application.

   This method is called by the `onOpenURL(perform:)` view modifier directly
   above.
   */
  func handleURL(_ url: URL) {
      
      // **Always** validate URLs; they offer a potential attack vector into
      // your app.
      guard url.scheme == self.spotify.loginCallbackURL.scheme else {
          print("not handling URL: unexpected scheme: '\(url)'")
          self.alert = AlertItem(
              title: "Cannot Handle Redirect",
              message: "Unexpected URL"
          )
          return
      }
      
      print("received redirect from Spotify: '\(url)'")
      
      // This property is used to display an activity indicator in `LoginView`
      // indicating that the access and refresh tokens are being retrieved.
      spotify.isRetrievingTokens = true
      
      // Complete the authorization process by requesting the access and
      // refresh tokens.
      spotify.api.authorizationManager.requestAccessAndRefreshTokens(
          redirectURIWithQuery: url,
          // This value must be the same as the one used to create the
          // authorization URL. Otherwise, an error will be thrown.
          state: spotify.authorizationState
      )
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
          // Whether the request succeeded or not, we need to remove the
          // activity indicator.
          self.spotify.isRetrievingTokens = false
          
          /*
           After the access and refresh tokens are retrieved,
           `SpotifyAPI.authorizationManagerDidChange` will emit a signal,
           causing `Spotify.authorizationManagerDidChange()` to be called,
           which will dismiss the loginView if the app was successfully
           authorized by setting the @Published `Spotify.isAuthorized`
           property to `true`.

           The only thing we need to do here is handle the error and show it
           to the user if one was received.
           */
          if case .failure(let error) = completion {
              print("couldn't retrieve access and refresh tokens:\n\(error)")
              let alertTitle: String
              let alertMessage: String
              if let authError = error as? SpotifyAuthorizationError,
                 authError.accessWasDenied {
                  alertTitle = "You Denied The Authorization Request :("
                  alertMessage = ""
              }
              else {
                  alertTitle =
                      "Couldn't Authorization With Your Account"
                  alertMessage = error.localizedDescription
              }
              self.alert = AlertItem(
                  title: alertTitle, message: alertMessage
              )
          }
      })
      .store(in: &cancellables)
      
      // MARK: IMPORTANT: generate a new value for the state parameter after
      // MARK: each authorization request. This ensures an incoming redirect
      // MARK: from Spotify was the result of a request made by this app, and
      // MARK: and not an attacker.
      self.spotify.authorizationState = String.randomURLSafe(length: 128)
  }

  func deAuthorize(){
    spotify.api.authorizationManager.deauthorize()
    self.isAuthorized = false
  }
}
