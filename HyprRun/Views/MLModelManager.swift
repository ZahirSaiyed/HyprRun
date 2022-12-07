//
//  MLModelManager.swift
//  HyprRun
//
//  Created by Zahir Saiyed on 12/6/22.
//

import CoreML

class MLModelManager {
		//let model: MusicRunning
		let model: MLModel

		init() {
			guard let modelURL = Bundle.main.url(forResource: "MusicRunning", withExtension: "mlmodel") else {
					// Handle error
				print("Error: Could not load model from app bundle")
				model = MLModel() // Use an empty model
				return
			}
//			let modelURL = URL(string: "/Users/zahirsaiyed/Documents/67443/HyprRun/HyprRun/Views/MusicRunning.mlmodel")!
			model = try! MLModel(contentsOf: modelURL)
			
			
//			model = try! MusicRunning(configuration: MLModelConfiguration.init())
		}

	func predict(_ input: MusicRunningInput) -> MusicRunningOutput {
		return try! model.prediction(from: input) as! MusicRunningOutput
		//let toReturn =  try! model.prediction(input: input)
		//return toReturn
	}
}
