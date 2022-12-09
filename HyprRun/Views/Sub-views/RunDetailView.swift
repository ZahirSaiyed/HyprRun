//
//  RunDetailView.swift
//  HyprRun
//
//  Created by Katie Lin on 12/8/22.
//

import SwiftUI
import Foundation
import CoreData

struct RunDetailView: View {
  var run: Run
  @State var locations: [Location] = []
  
  var body: some View {
    HStack {
      Spacer().frame(width: 20)
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Date: ")
          Text(FormatDisplay.date(run.timestamp))
        }
        .font(.title)
        .fontWeight(.bold)
        HStack {
          Text("Distance: ")
          Text(FormatDisplay.distance(run.distance))
          Spacer()
        }
        HStack {
          Text("Time: ")
          Text(FormatDisplay.time(Int(run.duration)))
          Spacer()
        }
        ScrollView {
          ForEach(locations) { loc in
            HStack {
              VStack(alignment: .leading) {
                Text("Coordinate: \(loc.latitude), \(loc.longitude)")
              }
              Spacer()
            }
          }
        }
      }
      .onAppear(perform: fetchLocations)
    }
  }
}

extension RunDetailView {
  func fetchLocations() {
    let request: NSFetchRequest<Location> = Location.fetchRequest()
    request.predicate = NSPredicate(format: "run = %@", run)
    
    do {
      locations = try DataManager.shared.persistentContainer.viewContext.fetch(request)
    } catch let error {
      print("Error fetching locations: \(error)")
    }
  }
  
  //  func fetchLocations(run: Run) -> [Location] {
  //    let request: NSFetchRequest<Location> = Location.fetchRequest()
  //    request.predicate = NSPredicate(format: "run = %@", run)
  //    var fetchedLocations: [Location] = []
  //
  //    do {
  //      fetchedLocations = try persistentContainer.viewContext.fetch(request)
  //    } catch let error {
  //      print("Error fetching locations: \(error)")
  //    }
  //
  //    return fetchedLocations
  //  }

}
