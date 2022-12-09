//
//  metricLabel.swift
//  HyprRun
//
//  Created by Emily on 12/8/22.
//

import SwiftUI

struct MetricLabel: View {
  var metric: String
  var val: String
  
  init(metric: String, val: String){
    self.metric = metric
    self.val = val
  }
  
  var body: some View {
      HStack{
        Text(metric + ":")
          .font(.custom("HelveticaNeue", fixedSize: 24))
        Spacer()
        Text(val)
          .font(.custom("HelveticaNeue-Medium", fixedSize: 32))
      }
    }
}


