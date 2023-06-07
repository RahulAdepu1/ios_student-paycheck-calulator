//
//  TaxCalculatorView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/3/23.
//

import SwiftUI

 struct TaxCalculatorView: View {
    @State private var isShowingCamera = false
    @State private var isShowingCropView = false
    @State private var selectedImage: UIImage?
    @State private var isShowingTextView = false
    @State private var isSecondViewPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Step 1")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 200)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    Button {
                        isShowingCamera = true
                    } label: {
                        Text("Open Camera")
                            .modifier(CustomActionButtonDesign())
                    }
                    
                    VStack{
                        HStack{
                            Text("Pay type")
                                .modifier(CustomBlockDesign())
                            Text("Monthly")
                                .modifier(CustomBlockDesign())
                        }
                    }
                    
                    NavigationLink {
                        if let image = selectedImage {
                            SecondView(isPresented: $isSecondViewPresented)
                        }
                    } label: {
                        Text("Step 2")
                            .padding(15)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 30)
                    }
                    
                } else {
                    Button {
                        isShowingCamera = true
                    } label: {
                        Text("Open Camera")
                            .modifier(CustomActionButtonDesign())
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera, onDismiss: {
                if let image = selectedImage {
                    isShowingCropView = true
                }
            }) {
                ImagePickerView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $isShowingCropView, onDismiss: {
                if let image = selectedImage {
                    isShowingTextView = true
                }
            }) {
                if let image = selectedImage {
                    CropView(image: image, updatedSelectImage: $selectedImage, isPresented: $isShowingCropView)
                }
            }
            .sheet(isPresented: $isShowingTextView, onDismiss: {
                isSecondViewPresented = true
            }) {
                if let image = selectedImage {
                    TextView(image: image)
                }
            }
        }
    }
}


struct TaxCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        TaxCalculatorView()
    }
}


struct SecondView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Second View")
        }
        .navigationBarTitle("Second View")
        .navigationBarItems(leading: Button("Back") {
            isPresented = false
        })
    }
}

struct ResultView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Second View")
        }
        .navigationBarTitle("Second View")
        .navigationBarItems(leading: Button("Back") {
            isPresented = false
        })
    }
}
