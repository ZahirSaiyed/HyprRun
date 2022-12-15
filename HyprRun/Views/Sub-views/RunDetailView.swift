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
        Text((FormatDisplay.date(run.timestamp)))
          .font(.custom("HelveticaNeue-Medium", fixedSize: 32))
//        MetricLabel(metric: "", val: "\(FormatDisplay.date(run.timestamp))")
        
        MetricLabel(metric: "Distance", val: "\(FormatDisplay.distance(run.distance))")
        
        MetricLabel(metric: "Duration", val: "\(FormatDisplay.time(Int(run.duration)))")

//        HStack {
//          Text("Time: ")
//          Text(FormatDisplay.time(Int(run.duration)))
//          Spacer()
//        }
        ScrollView {
          ForEach(locations) { loc in
            HStack {
              VStack(alignment: .leading) {
                Text("Coordinate: \(loc.latitude), \(loc.longitude)")
                  .font(.custom("HelveticaNeue-Medium", fixedSize: 16))
                  .foregroundColor(.gray)
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
