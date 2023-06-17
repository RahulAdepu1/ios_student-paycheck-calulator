//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI
import UIKit


struct ContentView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("No image selected")
            }
            Button("Select Image") {
                showImagePicker = true
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.showsCameraControls = true
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .off
        picker.cameraCaptureMode = .photo
        return picker
    }


    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            picker.dismiss(animated: true)
            
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func showCrop(image: UIImage) {
//            let vc = CropViewController(
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ContentView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
    }
}

struct TaxResultView:View {
    
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    
    var body: some View{
        VStack{
            Text(String(format: "%.2f", effectiveTaxCalculator.currentTotalGross))
            Text(String(format: "%.2f", effectiveTaxCalculator.currentNetPay))
            Text(String(format: "%.2f", effectiveTaxCalculator.currentTotalTax))
        }
    }
}
