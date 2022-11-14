//
//  ContentView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 10/31/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct ContentView: View {
  @StateObject private var viewRouter = ViewRouter()
  @State var root: Route = .homeView
  
  @EnvironmentObject var spotify: Spotify
  @ObservedObject var viewModel: UIViewModel = UIViewModel()
  
  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  
  @Binding var isAuthorized: Bool
  
  
  var body: some View {
    switch viewRouter.root {
    case Route.homeView:
      if !self._isAuthorized.wrappedValue{
        SplashView(isAuthorized: $isAuthorized)
      } else {
        HomeView(viewModel: self.viewModel, isAuthorized: $isAuthorized).environmentObject(self.viewRouter)
      }
    case Route.splashView:
      SplashView(isAuthorized: $isAuthorized)
    case Route.runView:
      SplashView(isAuthorized: $isAuthorized)
      // Need to change this to be run view
    case Route.postRunView:
      SplashView(isAuthorized: $isAuthorized)
      // Need to change this to be the post-run view
    }
  }
}
