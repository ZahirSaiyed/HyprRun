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
      
      VStack(spacing: 14){
        MetricLabel(metric: "Time", val: "\(self.runViewModel.timeLabel)")
        
        MetricLabel(metric: "Distance", val: "\(self.runViewModel.distanceLabel)")
        
        MetricLabel(metric: "Pace", val: "\(self.runViewModel.paceLabel)")
      }
      .padding()

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
