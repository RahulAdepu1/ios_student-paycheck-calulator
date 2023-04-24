//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

//import SwiftUI
//
//struct CameraView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIImagePickerController
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.cameraDevice = .rear
//        picker.cameraCaptureMode = .photo
//        picker.showsCameraControls = false
//        picker.allowsEditing = true
//
//        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        overlayView.backgroundColor = UIColor.clear
//        let rectLayer = CAShapeLayer()
//        rectLayer.strokeColor = UIColor.white.cgColor
//        rectLayer.fillColor = UIColor.clear.cgColor
//        rectLayer.lineWidth = 2.0
//        rectLayer.lineDashPattern = [10, 5]
//        rectLayer.frame = overlayView.frame
//        rectLayer.path = UIBezierPath(rect: CGRect(x: (UIScreen.main.bounds.width - 300) / 2, y: (UIScreen.main.bounds.height - 100) / 2, width: 300, height: 100)).cgPath
//        overlayView.layer.addSublayer(rectLayer)
//
//        let label = UILabel(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
//        label.text = "Barcode Scanner"
//        label.textAlignment = .center
//        label.textColor = .white
//        overlayView.addSubview(label)
//
//        picker.cameraOverlayView = overlayView
//
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.editedImage] as? UIImage {
//                // Handle the captured image here
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//struct ContentView: View {
//    @State private var showCamera = false
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                self.showCamera.toggle()
//            }) {
//                Text("Take Picture")
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//        }
//        .sheet(isPresented: $showCamera) {
//            CameraView()
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

import SwiftUI

struct FirstView: View {
    @State var data = [DataModel]()
    @State var selectedDate = Date()
    @State var amount = ""
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                TextField("Enter Amount", text: $amount)
                    .keyboardType(.decimalPad)
                Button("Add") {
                    if let doubleAmount = Double(amount) {
                        let calendar = Calendar.current
                        let year = calendar.component(.year, from: selectedDate)
                        if data.contains(where: { Calendar.current.component(.year, from: $0.selectedDate) == year }) {
                            data.append(DataModel(selectedDate: selectedDate, amount: doubleAmount))
                        }
                        else {
                            let month = calendar.component(.month, from: selectedDate)
                            for m in 1...12 {
                                let dateComponents = DateComponents(year: year, month: m, day: 1)
                                if let date = calendar.date(from: dateComponents) {
                                    if m == month {
                                        data.append(DataModel(selectedDate: selectedDate, amount: doubleAmount))
                                    } else {
                                        data.append(DataModel(selectedDate: date, amount: 0.0))
                                    }
                                }
                            }
                        }
                    }
                    amount = ""
                }
                
                NavigationLink(destination: SecondView(data: data)) {
                                    Text("Show")
                                }
                .disabled(data.isEmpty)
                Button("Start") {
                    let calendar = Calendar.current
                    let currentDate = Date()
                    for month in 1...12 {
                        let year = calendar.component(.year, from: currentDate)
                        let dateComponents = DateComponents(year: year, month: month, day: 1)
                        if let date = calendar.date(from: dateComponents) {
                            let newData = DataModel(selectedDate: date, amount: 0)
                            data.append(newData)
                        }
                    }
                }
            }
            .navigationTitle("First View")
        }
    }
}

struct SecondView: View {
    let data: [DataModel]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(data.sorted(by: { $0.selectedDate < $1.selectedDate })) { item in
                    HStack {
                        Text("\(item.selectedDate, formatter: DateFormatter.monthYearFormat) :")
                        Spacer()
                        Text("\(item.amount, specifier: "%.2f")")
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Second View")
    }
}

extension DateFormatter {
    static let monthYearFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

struct DataModel: Identifiable {
    let id: String
    let selectedDate: Date
    let amount: Double
    
    init(id: String = UUID().uuidString, selectedDate: Date, amount: Double) {
        self.id = id
        self.selectedDate = selectedDate
        self.amount = amount
    }
}
