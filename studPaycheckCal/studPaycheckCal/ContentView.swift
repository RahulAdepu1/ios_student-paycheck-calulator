//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct NumberSelectionView: View {
    @StateObject var viewModel = NumberSelectionViewModel()
    
    var body: some View {
        VStack {
            Picker("Number 1", selection: $viewModel.number1) {
                ForEach(1...100, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Picker("Number 2", selection: $viewModel.number2) {
                ForEach(1...100, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Button("Multiply") {
                viewModel.multiplyNumbers()
            }
            .disabled(!viewModel.canNavigateToNextView)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
            
            NavigationLink(
                destination: ResultView(result: viewModel.result),
                isActive: $viewModel.navigateToNextView) {
                EmptyView()
            }
        }
        .navigationTitle("Number Selection")
    }
}

struct ResultView: View {
    let result: Int
    
    var body: some View {
        Text("Result: \(result)")
            .font(.title)
            .padding()
    }
}

class NumberSelectionViewModel: ObservableObject {
    @Published var number1 = 1
    @Published var number2 = 1
    @Published var result = 1
    @Published var navigateToNextView = false
    
    var canNavigateToNextView: Bool {
        return number1 != 1 && number2 != 1
    }
    
    func multiplyNumbers() {
        result = number1 * number2
        navigateToNextView = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NumberSelectionView()
        }
    }
}
