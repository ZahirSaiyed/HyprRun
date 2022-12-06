//
//  Route.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//

import Foundation

enum Route: String {
  case splashView
  case homeView
  case runView
  case postRunView
  
  // TODO: Change homeView to be two different cases: homeRunView (the default state) and homeRewindView - this way, we can use ViewRouter to direct users to the 'Rewind' view after they're done viewing their post-run view. Inside of ContentView, I'll need to add a @State variable to track 'runStateToggled' or a similarly named variable. This will allow us to pass in the correct view, which is displayed based on whether the runState is toggled or not.
}
