//
//  ContentView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct FirstView: View {
    @State var backToStart: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("First View")
                    .font(.headline)
                    .padding()
                NavigationLink(destination: SecondView(backToStart: $backToStart)) {
                    Text("Go to Second View")
                }
            }
        }
        .onAppear {
            backToStart = true
        }
    }
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var backToStart: Bool
    
    var body: some View {
        VStack {
            Text("Second View")
                .font(.headline)
                .padding()
            
            NavigationLink(destination: ThirdView(backToStart: $backToStart)) {
                Text("Go to Third View")
            }
        }
        .onAppear {
            if !backToStart {
                dismiss()
            }
        }
    }
}

struct ThirdView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var backToStart: Bool
    
    var body: some View {
        VStack {
            Text("Third View")
                .font(.headline)
                .padding()
            
            NavigationLink(destination: FourthView(backToStart: $backToStart)) {
                Text("Go to Fourth View")
            }
        }
        .onAppear {
            if !backToStart {
                dismiss()
            }
        }
    }
}

struct FourthView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var backToStart: Bool
    
    var body: some View {
        VStack {
            Text("Fourth View")
                .font(.headline)
                .padding()
            
            Button(action: {
                backToStart = false
                dismiss()
            }) {
                Text("Go to First View")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FirstView()
        }
    }
}
