//
//  PostRunView.swift
//  HyprRun
//
//  Created by Katie Lin on 11/15/22.
//

import SwiftUI

struct PostRunView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  @ObservedObject var runViewModel: UIRunViewModel
  
  var body: some View {
    VStack() {
      Text("This is the post-run view").font(.title2)
      Spacer()
      Text("Distance: \(self.runViewModel.distanceLabel)")
      Text("Duration: \(self.runViewModel.timeLabel)")
      Text("Average Pace: \(self.runViewModel.paceLabel)")
      Spacer()
      Button(action: {
        self.viewRouter.rewindView()
        self.viewRouter.setRoute(.homeView)
      }, label: {
        Text("Finish").font(.custom("HelveticaNeue-Bold", fixedSize: 18))
          .foregroundColor(.white)
          .padding(7)
          .frame(width: 150, height: 50)
          .background(Color.blue)
          .cornerRadius(20)
          .shadow(radius: 5)
      })
      Spacer()
    }
  }
}
