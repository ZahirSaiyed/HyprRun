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
  @Environment(\.colorScheme) var currentMode
  
  @ObservedObject var runViewModel: UIRunViewModel

  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  
  @Binding var runViewToggled: Bool
  @Binding var isAuthorized: Bool
  
	@Binding var selectedPlaylists: [Playlist<PlaylistItemsReference>]
  @Binding var playlists: [Playlist<PlaylistItemsReference>]
  @Binding var tracks: [PlaylistItem]
  
//  @Binding var vibe: Float
	@Binding var vibe: String
  @Binding var isEditing: Bool
  
  var body: some View {
    NavigationStack {
      ZStack {
        // TODO: Add settings button/page
          // TODO: Reintegrate login button, inside of settings page
        VStack {
          Text("HYPRRUN")
            .font(.custom("HelveticaNeue-Bold", fixedSize: 18))
            .padding(.bottom, 8)
          HStack {
            Spacer()
            Button(action: {
              self.viewRouter.runView()
//              runViewToggled = true
            }, label: {
              Text("Run")
                .font(.custom("HelveticaNeue-Medium", fixedSize: 24))
                .foregroundColor(runViewToggled == false ? .gray : ((currentMode == .dark) ? .white : .black))
            })
            Spacer()
              .frame(width: 40)
            Button(action: {
              self.viewRouter.rewindView()
//              runViewToggled = false
            }, label: {
              Text("Rewind")
                .font(.custom("HelveticaNeue-Medium", fixedSize: 24))
                .foregroundColor(runViewToggled == true ? .gray : ((currentMode == .dark) ? .white : .black))
            })
            Spacer()
          }
          Spacer()
            .frame(height: 24)
          displayToggledView()
        }
        .background(currentMode == .dark ? .black : .white)
        .foregroundColor(currentMode == .dark ? .white : .black)
        .frame(maxWidth: .infinity)
      }
//      .preferredColorScheme(isDarkMode ? .dark : .light)
      .modifier(LoginView())
      // Called when a redirect is received from Spotify
      .onOpenURL(perform: handleURL(_:))
    }
  }
  
  func displayToggledView() -> some View {
    return ZStack {
      if runViewToggled {
        homeRunView()
      } else {
        homeRewindView()
      }
    }
    .background(currentMode == .dark ? .black : .white)
    .foregroundColor(currentMode == .dark ? .white : .black)
  }
  
//  @State private var isDarkMode = true
//  // Need to nest the toggle inside of a View
//  //      Toggle("Dark Mode", isOn: $isDarkMode)
//  //      Spacer()
}



extension HomeView {
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
