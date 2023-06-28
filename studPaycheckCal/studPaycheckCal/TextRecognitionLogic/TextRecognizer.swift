//
//  TextRecognizer.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//


import SwiftUI
import CropViewController
import Vision
import VisionKit

final class TextRecognizer{
    func detectText(image: UIImage) -> String {
        var detectedText = ""
        let textRecognitionRequest = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let text = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            detectedText = text
        }
        
        textRecognitionRequest.recognitionLevel = .accurate
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Error: \(error)")
        }
        return detectedText
    }
}
