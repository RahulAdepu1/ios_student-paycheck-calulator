//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCountry = "USA"
    @State private var selectedCity = "New York"
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Country", selection: $selectedCountry) {
                    Text("USA").tag("USA")
                    Text("Canada").tag("Canada")
                    Text("Mexico").tag("Mexico")
                }
                .pickerStyle(.wheel)
                
                Picker("City", selection: $selectedCity) {
                    switch selectedCountry {
                    case "USA":
                        Text("New York").tag("New York")
                        Text("Los Angeles").tag("Los Angeles")
                        Text("Chicago").tag("Chicago")
                    case "Canada":
                        Text("Toronto").tag("Toronto")
                        Text("Montreal").tag("Montreal")
                        Text("Vancouver").tag("Vancouver")
                    case "Mexico":
                        Text("Mexico City").tag("Mexico City")
                        Text("Cancun").tag("Cancun")
                        Text("Guadalajara").tag("Guadalajara")
                    default:
                        Text("Error")
                    }
                }
                .pickerStyle(.wheel)
                
                NavigationLink(
                    destination: SecondView(),
                    label: {
                        Text("Go to Next View")
                    })
                    .disabled(selectedCountry == "USA" && selectedCity == "New York")
                    .onChange(of: selectedCountry, perform: { _ in
                        isShowingAlert = true
                    })
                    .onChange(of: selectedCity, perform: { _ in
                        isShowingAlert = true
                    })
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Picker values have not changed"),
                            message: Text("Please select a different value for the pickers to proceed."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
            .navigationTitle("Pickers and Navigation")
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("This is the Second View")
            .navigationTitle("Second View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
