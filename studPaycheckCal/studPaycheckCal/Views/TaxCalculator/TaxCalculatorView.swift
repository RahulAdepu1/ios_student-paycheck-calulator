//
//  TaxCalculatorView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/3/23.
//

import SwiftUI

struct TaxCalculatorView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @State var textRecognizer = TextRecognizer()
    
    @State private var payType: String = ""
    
    @State private var isShowingCamera = false
    @State private var isShowingCropView = false
    @State private var selectedImage: UIImage?
    @State private var isShowingTextView = false
    @State private var isSecondViewPresented = false
    @State private var isShowYearPicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Step 1")
                    .font(.largeTitle)
                    .bold()
                Text("Take an image of your paycheck \nwhich mentions the pay type/group")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 100)
                }else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding(.bottom, 100)
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: -10){
                        Text("Pay type")
                            .padding(0)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        if let image = selectedImage {
                            Text(detectText(image: image))
                                .frame(maxWidth: .infinity)
                        }else {
                            Text("-----")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 30)
                
                VStack(spacing: 0) {
                    HStack(spacing: -10){
                        Text("Pay Year")
                            .padding(0)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        if selectedImage != nil {
                            Button {
                                isShowYearPicker = true
                            } label: {
                                Text(studentPaycheckCalVM.selectedYear)
                                    .modifier(CustomActionButtonDesign())
                            }
                        }else {
                            Text("-----")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 30)
                
                if selectedImage != nil {
                    HStack {
                        Button {
                            isShowingCamera = true
                        } label: {
                            Text("Open Camera")
                                .modifier(CustomActionButtonDesign())
                                .padding(.trailing, -15)
                        }
                        
                        NavigationLink {
                            if selectedImage != nil {
                                SecondView()
                            }
                        } label: {
                            Text("Step 2")
                                .modifier(CustomActionButtonDesign())
                                .padding(.leading, -15)
                        }
                    }
                    
                    Button {
                        selectedImage = nil
                    } label: {
                        Text("Clear")
                            .modifier(CustomActionButtonDesign())
                    }

                    
                }else {
                    Button {
                        isShowingCamera = true
                    } label: {
                        Text("Open Camera")
                            .modifier(CustomActionButtonDesign())
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera, onDismiss: {
                if selectedImage != nil {
                    isShowingCropView = true
                }
            }) {
                ImagePickerView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $isShowingCropView, onDismiss: {
                if selectedImage != nil {
                    isShowingTextView = true
                }
            }) {
                if let image = selectedImage {
                    CropView(image: image, updatedSelectImage: $selectedImage, isPresented: $isShowingCropView)
                }
            }
            .sheet(isPresented: $isShowYearPicker) {
                YearSelectPicker()
                    .presentationDetents([.height(200)])
            }
        }
    }
    
    func detectText(image: UIImage) -> String {
        let text = textRecognizer.detectText(image: image).components(separatedBy: "\n")
        
        print("*********************************************")
        for i in 0..<text.count {
            print(text[i])
            
            if text[i].contains("Monthly 63-901"){
                payType = "Monthly"
                break
            }else {
                payType = "Bi-Monthly"
            }
        }
        return payType
    }
}

struct TaxCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TaxCalculatorView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(EffectiveTaxCalculator())
    }
}

struct SecondView: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @State var textRecognizer = TextRecognizer()
    
    @State private var detectedText: String = ""
    
    @State private var isShowingCamera = false
    @State private var isShowingCropView = false
    @State private var selectedImage: UIImage?
    @State private var isShowingTextView = false
    @State private var isSecondViewPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Step 2")
                    .font(.largeTitle)
                    .bold()
                Text("Take an image of your paycheck \nwhich mentions the pay type")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 100)
                }else {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.bottom, 100)
                }
                
                if let image = selectedImage {
                    DetectedTextView(textTitle: "Taxable Gross", detectedText: detectText(image: image)[0])
                    DetectedTextView(textTitle: "Total Tax", detectedText: detectText(image: image)[1])
                    DetectedTextView(textTitle: "Net Pay", detectedText: detectText(image: image)[2])
                }else {
                    DetectedTextView(textTitle: "Taxable Gross", detectedText: "-----")
                    DetectedTextView(textTitle: "Total Tax", detectedText: "-----")
                    DetectedTextView(textTitle: "Net Pay", detectedText: "-----")
                }
                
                if selectedImage != nil {
                    HStack {
                        Button {
                            isShowingCamera = true
                        } label: {
                            Text("Open Camera")
                                .modifier(CustomActionButtonDesign())
                                .padding(.trailing, -15)
                        }
                        
                        NavigationLink {
                            if selectedImage != nil {
                                ResultView()
                            }
                        } label: {
                            Text("Result")
                                .modifier(CustomActionButtonDesign())
                                .padding(.leading, -15)
                        }
                    }
                    
                    Button {
                        selectedImage = nil
                    } label: {
                        Text("Clear")
                            .modifier(CustomActionButtonDesign())
                    }
                }else {
                    Button {
                        isShowingCamera = true
                    } label: {
                        Text("Open Camera")
                            .modifier(CustomActionButtonDesign())
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera, onDismiss: {
                if selectedImage != nil {
                    isShowingCropView = true
                }
            }) {
                ImagePickerView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $isShowingCropView, onDismiss: {
                if selectedImage != nil {
                    isShowingTextView = true
                }
            }) {
                if let image = selectedImage {
                    CropView(image: image, updatedSelectImage: $selectedImage, isPresented: $isShowingCropView)
                }
            }
        }
    }
        
    func detectText(image: UIImage) -> [String] {
        let text = textRecognizer.detectText(image: image).components(separatedBy: "\n")
        var currentFedTaxableGross = ""
        var currentTotalTax = ""
        var currentNetPay = ""
        
        
        for i in 0..<text.count {
            if text[i] == "TOTAL GROSS" {
                currentFedTaxableGross = text[i+1]
            }
            
            if text[i] == "TOTAL TAXES" {
                currentTotalTax = text[i+1]
            }
            
            if text[i] == "NET PAY" {
                currentNetPay = text[i+1]
            }
        }
        
//        effectiveTaxCalculator.$currentNetPay = currentNetPay
        
        return [currentFedTaxableGross, currentTotalTax, currentNetPay]
    }
}

struct ResultView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM

    var body: some View {
        VStack(spacing:50) {
            Text("Final Result")
                .font(.largeTitle)
                .fontWeight(.heavy)
            FederalTax_TaxCal(marginalFedTaxRate: federalTax()[0].doubleToString1, effectiveFedTaxRate: federalTax()[1].doubleToString1)
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
            StateTax_TaxCal(marginalStateTaxRate: stateTax()[0], effectiveStateTaxRate: stateTax()[1])
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
            TotalTax_TaxCal(marginalTotalTaxRate: totalTax()[0], effectiveTotalTaxRate: totalTax()[1])
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
        }
    }
    
    func federalTax() -> [Double] {
        let marginalFederalTaxRate = 0.0
        let effectiveFederalTaxRate = 0.0
        
        return [marginalFederalTaxRate, effectiveFederalTaxRate]
    }
    
    func stateTax() -> [String] {
        let marginalStateTaxRate = "0.00%"
        let effectiveStateTaxRate = "0.00%"
        
        return [marginalStateTaxRate, effectiveStateTaxRate]
    }
    
    func totalTax() -> [String] {
        let marginalTotalTaxRate = "0.00%"
        let effectiveTotalTaxRate = "0.00%"
        
        return [marginalTotalTaxRate, effectiveTotalTaxRate]
    }
    
}

struct DetectedTextView: View {
    var textRecognizer = TextRecognizer()
    
    @State var textTitle: String
    @State var detectedText: String
    @State var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: -10){
                Text(textTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                Text(detectedText)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .foregroundColor(.black)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 30)
    }
}

struct FederalTax_TaxCal: View {
    var marginalFedTaxRate: String
    var effectiveFedTaxRate: String
    
    var body: some View {
        VStack(spacing:10) {
            Text("Federal Tax")
                .font(.title)
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            HStack {
                VStack(spacing:10) {
                    Text("Marginal Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(marginalFedTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
                
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveFedTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
            }
        }
    }
}

struct StateTax_TaxCal: View {
    var marginalStateTaxRate: String
    var effectiveStateTaxRate: String
    
    var body: some View {
        VStack(spacing:10) {
            Text("State Tax")
                .font(.title)
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            HStack {
                VStack(spacing:10) {
                    Text("Marginal Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(marginalStateTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
                
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveStateTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
            }
        }
    }
}

struct TotalTax_TaxCal: View {
    var marginalTotalTaxRate: String
    var effectiveTotalTaxRate: String
    
    var body: some View {
        VStack(spacing:10) {
            Text("Total Tax")
                .font(.title)
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            HStack {
                VStack(spacing:10) {
                    Text("Marginal Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(marginalTotalTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
                
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveTotalTaxRate)
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
            }
        }
    }
}

struct YearSelectPicker: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    
    var body: some View{
        VStack{
            Text(effectiveTaxCalculator.payYear)
                .padding(.top, 20)
                .font(.title)
            Picker("", selection: $effectiveTaxCalculator.payYear) {
                ForEach(Year.yearList){ year in
                    Text(year.year).tag(year.year)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

