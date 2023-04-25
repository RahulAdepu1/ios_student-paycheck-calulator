//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet = false
    @State private var texts:[ScanData] = []
    var body: some View {
        NavigationView{
            VStack{
                if texts.count > 0{
                    List{
                        ForEach(texts){text in
                            NavigationLink(
                                destination:ScrollView{Text(text.content)},
                                label: {
                                    Text(text.content).lineLimit(1)
                                })
                        }
                    }
                }
                else{
                    Text("No scan yet").font(.title)
                }
            }
                .navigationTitle("Scan OCR")
                .navigationBarItems(trailing: Button(action: {
                    self.showScannerSheet = true
                }, label: {
                    Image(systemName: "doc.text.viewfinder")
                        .font(.title)
                })
                .sheet(isPresented: $showScannerSheet, content: {
                    self.makeScannerView()
                })
                )
        }
    }
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// LOGIC FOR CREATING A DICTIONARY WITH PREDEFINED VALUES
//
//import SwiftUI
//
//struct FirstView: View {
//    @State var data = [DataModel]()
//    @State var selectedDate = Date()
//    @State var amount = ""
//    var body: some View {
//        NavigationView {
//            VStack {
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                TextField("Enter Amount", text: $amount)
//                    .keyboardType(.decimalPad)
//
//                Button("Add") {
//                    if let doubleAmount = Double(amount) {
//                        let calendar = Calendar.current
//                        let year = calendar.component(.year, from: selectedDate)
//                        if data.contains(where: { Calendar.current.component(.year, from: $0.selectedDate) == year }) {
//                            data.append(DataModel(selectedDate: selectedDate, amount: doubleAmount))
//                        }
//                        else {
//                            let month = calendar.component(.month, from: selectedDate)
//                            for m in 1...12 {
//                                let dateComponents = DateComponents(year: year, month: m, day: 1)
//                                if let date = calendar.date(from: dateComponents) {
//                                    if m == month {
//                                        data.append(DataModel(selectedDate: selectedDate, amount: doubleAmount))
//                                    } else {
//                                        data.append(DataModel(selectedDate: date, amount: 0.0))
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    amount = ""
//                }
//
//                NavigationLink(destination: SecondView(data: data)) {
//                                    Text("Show")
//                                }
//                .disabled(data.isEmpty)
//            }
//            .navigationTitle("First View")
//        }
//        .onAppear {
//            createAnEmptyData()
//        }
//    }
//
//    func createAnEmptyData() {
//        let calendar = Calendar.current
//        let currentDate = Date()
//        for month in 1...12 {
//            let year = calendar.component(.year, from: currentDate)
//            let dateComponents = DateComponents(year: year, month: month, day: 1)
//            if let date = calendar.date(from: dateComponents) {
//                let newData = DataModel(selectedDate: date, amount: 0)
//                data.append(newData)
//            }
//        }
//    }
//}
//
//struct SecondView: View {
//    let data: [DataModel]
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                ForEach(data.sorted(by: { $0.selectedDate < $1.selectedDate })) { item in
//                    HStack {
//                        Text("\(item.selectedDate, formatter: DateFormatter.monthYearFormat) :")
//                        Spacer()
//                        Text("\(item.amount, specifier: "%.2f")")
//                    }
//                    .padding(.vertical, 8)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Second View")
//    }
//}
//
//extension DateFormatter {
//    static let monthYearFormat: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter
//    }()
//}
//
//struct DataModel: Identifiable {
//    let id: String
//    let selectedDate: Date
//    let amount: Double
//
//    init(id: String = UUID().uuidString, selectedDate: Date, amount: Double) {
//        self.id = id
//        self.selectedDate = selectedDate
//        self.amount = amount
//    }
//}
