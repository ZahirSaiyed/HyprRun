//
//  SelectButtonView.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 11/6/22.
//

import SwiftUI

struct SelectBoxView: View {
		@Binding var selected: Bool

		var body: some View {
				Image(systemName: selected ? "checkmark.square.fill" : "square")
						.foregroundColor(selected ? Color(UIColor.systemBlue) : Color.secondary)
						.onTapGesture {
								self.selected.toggle()
						}
		}
}

