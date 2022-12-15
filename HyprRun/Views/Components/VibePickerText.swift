//
//  VibePickerText.swift
//  HyprRun
//
//  Created by Emily on 12/15/22.
//

import SwiftUI

struct VibePickerText: View {

  var vibe: String
  var body: some View {
        Text("\(vibe)")
          .font(Font.system(size: 46, weight: .bold))
          .multilineTextAlignment(.center)
          .foregroundStyle(
              LinearGradient(
                  colors: [.red, .blue, .green, .yellow],
                  startPoint: .leading,
                  endPoint: .trailing
              )
          )
    }
}



