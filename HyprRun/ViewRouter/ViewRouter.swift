//
//  ViewRouter.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//

import Foundation
import Combine

class ViewRouter: ObservableObject {
  @Published var root: Route = .splashView
  
  private let routeSubject = PassthroughSubject<Route, Never>()
  private var cancellable: AnyCancellable?
  
  init() {
    cancellable = self.routeSubject
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [unowned self] in self.root = $0 })
  }
  
  func setRoute(_ route: Route) {
    routeSubject.send(route)
  }
}
