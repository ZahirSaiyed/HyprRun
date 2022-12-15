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
      Spacer()
      Text("Run Complete!")
        .font(.custom("HelveticaNeue-Bold", fixedSize: 36))
        .foregroundStyle(hyprGreen)
        .padding(.bottom, 4)
      
      Spacer()
        .frame(maxHeight: 28)
      VStack(spacing: 14){
        MetricLabel(metric: "Time", val: "\(self.runViewModel.timeLabel)")

        MetricLabel(metric: "Distance", val: "\(self.runViewModel.distanceLabel)")

        MetricLabel(metric: "Pace", val: "\(self.runViewModel.paceLabel)")
      }
      .padding(20)

      Spacer()

      Button(action: {
        self.viewRouter.rewindView()
        self.viewRouter.setRoute(.homeView)
      }, label: {
        Text("Finish")
          .font(.custom("HelveticaNeue-Bold", fixedSize: 28))
          .foregroundColor(.white)
          .padding(7)
          .frame(width: 250, height: 50)
          .background(hyprBlue)
          .cornerRadius(50)
          .shadow(radius: 10)
      })
      
      Spacer()
        .frame(maxHeight: 35)
    }
  }
}
