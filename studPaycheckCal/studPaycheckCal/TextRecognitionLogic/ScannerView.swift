//
//  ScannerView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI
import CropViewController
import Vision
import VisionKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
        //        imagePicker.
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct CropView: UIViewControllerRepresentable {
    var image: UIImage
    @Binding var updatedSelectImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> CropViewController {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetOriginal
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Done"
        vc.cancelButtonTitle = "Cancel"
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: CropView
        
        init(_ parent: CropView) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            // Handle cropped image
            parent.updatedSelectImage = image
            parent.isPresented = false
        }
    }
}

struct TextView: View {
    let image: UIImage
    @State private var detectedText: String = ""
    
    var body: some View {
        VStack {
            Text(detectedText)
                .font(.title)
                .padding()
            
            Spacer()
        }
        .onAppear {
            detectText()
        }
    }
    
    func detectText() {
        let textRecognitionRequest = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let detectedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            self.detectedText = detectedText
        }
        
        textRecognitionRequest.recognitionLevel = .accurate
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Error: \(error)")
        }
    }
}
