//
//  TaxCalculatorView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/3/23.
//

import SwiftUI

struct TaxCalculatorView: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @State var textRecognizer = TextRecognizer()
    
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
                Text("Take an image of your paycheck \nwhich mentions the pay type")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, UIScreen.main.bounds.height*0.05)
                }else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, UIScreen.main.bounds.height*0.05)
                }
                
                if let image = selectedImage {
                    DetectedTextView(textTitle: "Total Gross",
                                     detectedText: detectText(image: image)[0].currencyFormattedString)
                    DetectedTextView(textTitle: "Total Tax",
                                     detectedText: detectText(image: image)[1].currencyFormattedString)
                    DetectedTextView(textTitle: "Net Pay",
                                     detectedText: detectText(image: image)[2].currencyFormattedString)
                }else {
                    DetectedTextView(textTitle: "Total Gross", detectedText: "---")
                    DetectedTextView(textTitle: "Total Tax", detectedText: "---")
                    DetectedTextView(textTitle: "Net Pay", detectedText: "---")
                }
                
                if selectedImage != nil {
                    HStack {
                        Button {
                            selectedImage = nil
                        } label: {
                            Text("Clear")
                                .modifier(CustomActionButtonDesign())
                        }
                        
                        NavigationLink {
                            SecondView_TaxCalView(selectedImage: $selectedImage, isSecondViewPresented: $isSecondViewPresented)
                        } label: {
                            Text("Step 2")
                                .modifier(CustomActionButtonDesign())
                                .padding(.leading, -15)
                        }
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
                if let image = selectedImage {
                    updateEffectiveTaxCalculatorValues(with: image)
                }
            }) {
                if let image = selectedImage {
                    CropView(image: image, updatedSelectImage: $selectedImage, isPresented: $isShowingCropView)
                }
            }
        }
    }
        
    func detectText(image: UIImage) -> [String]{
        let text = textRecognizer.detectText(image: image).components(separatedBy: "\n")
        var currentTotalGross = ""
        var currentTotalTax = ""
        var currentNetPay = ""
        
        for i in 0..<text.count {
//            print("\(i)-",text[i])
            if text[i] == "TOTAL GROSS" {
                currentTotalGross = text[i+1]
            }
            
            if text[i] == "TOTAL TAXES" {
                currentTotalTax = text[i+1]
            }
            
            if text[i] == "NET PAY" {
                currentNetPay = text[i+1]
            }
        }
        
//        print("currentTotalGross-",currentTotalGross)
//        print("currentTotalTax-",currentTotalTax)
//        print("currentNetPay-",currentNetPay)
        
        return [currentTotalGross, currentTotalTax, currentNetPay]
    }
    
    func updateEffectiveTaxCalculatorValues(with image: UIImage) {
        let updatedValues = detectText(image: image)
        // Update the effectiveTaxCalculator values outside of the view update
        effectiveTaxCalculator.currentTotalGross = updatedValues[0]
        effectiveTaxCalculator.currentTotalTax = updatedValues[1]
        effectiveTaxCalculator.currentNetPay = updatedValues[2]
    }
}

struct TaxCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TaxCalculatorView()
//            SecondView_TaxCalView()
//            ResultView()
        }
        .environmentObject(EffectiveTaxCalculator())
    }
}

struct SecondView_TaxCalView: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Environment(\.dismiss) var dismiss
    
    @State private var showYearPicker:Bool = false
    @State private var showMaritalStatusPicker:Bool = false
    @State private var showStatePicker:Bool = false
    @State private var showSalaryTypePicker:Bool = false
    @Binding var selectedImage: UIImage?
    
    @State private var showAlert: Bool = false
    
    @Binding var isSecondViewPresented: Bool
    
    var body: some View {
        
        NavigationStack{
            Text("Make a choice for all the options \nto move to next page")
                .multilineTextAlignment(.center)
                .padding(10)
            VStack {
                HStack{
                    VStack {
                        Text("Year")
                            .modifier(CustomTextDesign4())
                        Button {
                            showYearPicker = true
                        } label: {
                            Text(effectiveTaxCalculator.payYear)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .modifier(CustomBlockDesign())
                    
                    
                    VStack {
                        Text("Marital Status")
                            .modifier(CustomTextDesign4())
                        Button {
                            showMaritalStatusPicker = true
                        } label: {
                            Text(effectiveTaxCalculator.currentMaritalStatus)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .modifier(CustomBlockDesign())
                }
                
                HStack{
                    VStack {
                        Text("State")
                            .modifier(CustomTextDesign4())
                        Button {
                            showStatePicker = true
                        } label: {
                            Text(effectiveTaxCalculator.currentState)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    VStack {
                        Text("Pay Frequency")
                            .modifier(CustomTextDesign4())
                        Button {
                            showSalaryTypePicker = true
                        } label: {
                            Text(effectiveTaxCalculator.payGroup)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            .padding(.bottom, UIScreen.main.bounds.height*0.05)
            
            NavigationLink {
                ResultView(selectedImage: $selectedImage, isSecondViewPresented: $isSecondViewPresented)
            } label: {
                Text("Result")
                    .modifier(CustomActionButtonDesign())
            }
            .disabled(!allValuesAdded)
            .opacity(allValuesAdded ? 1.0 : 0.5)
        }
        .sheet(isPresented: $showYearPicker) {
            YearSelectPicker_TaxCal(showYearPicker: $showYearPicker)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showMaritalStatusPicker) {
            MaritalStatusSelectPicker_TaxCal(showMaritalStatusPicker: $showMaritalStatusPicker)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showStatePicker) {
            StateSelectPicker_TaxCal(showStatePicker: $showStatePicker)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showSalaryTypePicker) {
            SalarySelectPicker_TaxCal(showSalaryTypePicker: $showSalaryTypePicker)
                .presentationDetents([.height(200)])
        }
        .onAppear {
            if !isSecondViewPresented{
                dismiss()
            }
        }
    }
}

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Binding var selectedImage: UIImage?
    
    @Binding var isSecondViewPresented: Bool

    var body: some View {
        VStack(spacing:50) {
            Text("Final Result")
                .font(.largeTitle)
                .fontWeight(.heavy)
            FederalTax_TaxCal(marginalFedTaxRate: effectiveTaxCalculator.calculateFedTax_TaxCal()[0].doubleToString2,
                              effectiveFedTaxRate: effectiveTaxCalculator.calculateFedTax_TaxCal()[1].doubleToString2)
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
            StateTax_TaxCal(marginalStateTaxRate: effectiveTaxCalculator.calculateStateTax_TaxCal()[0].doubleToString2,
                            effectiveStateTaxRate: effectiveTaxCalculator.calculateStateTax_TaxCal()[1].doubleToString2)
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
            TotalTax_TaxCal(effectiveTotalTaxRate: effectiveTaxCalculator.calculateTotalTax_TaxCal().doubleToString2)
                .modifier(CustomBlockDesign())
                .padding(.horizontal, 50)
                .padding(.bottom, UIScreen.main.bounds.height*0.02)
            
            Button {
                effectiveTaxCalculator.currentTotalGross = "---"
                effectiveTaxCalculator.currentNetPay = "---"
                effectiveTaxCalculator.currentTotalTax = "---"
                effectiveTaxCalculator.currentState = "Choose One"
                effectiveTaxCalculator.currentMaritalStatus = "Choose One"
                effectiveTaxCalculator.payGroup = "Choose One"
                effectiveTaxCalculator.payYear = "Choose One"
                selectedImage = nil
                isSecondViewPresented = false
                dismiss()
            } label: {
                Text("Done")
                    .modifier(CustomActionButtonDesign())
            }
        }
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
                    Text(marginalFedTaxRate+"%")
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
                
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveFedTaxRate+"%")
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
                    Text(marginalStateTaxRate+"%")
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
                
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveStateTaxRate+"%")
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
            }
        }
    }
}

struct TotalTax_TaxCal: View {
    var effectiveTotalTaxRate: String
    
    var body: some View {
        VStack(spacing:10) {
            Text("Total Tax")
                .font(.title)
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            HStack {
                VStack(spacing:10){
                    Text("Effective Tax Rate")
                        .font(.headline)
                        .modifier(CustomTextDesign3())
                    Text(effectiveTotalTaxRate+"%")
                        .font(.body)
                        .modifier(CustomTextDesign3())
                }
            }
        }
    }
}


//MARK: - Picker Views
struct YearSelectPicker_TaxCal: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Binding var showYearPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showYearPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $effectiveTaxCalculator.payYear) {
                ForEach(Year.yearList){ year in
                    Text(year.year).tag(year.year)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct MaritalStatusSelectPicker_TaxCal: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Binding var showMaritalStatusPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showMaritalStatusPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $effectiveTaxCalculator.currentMaritalStatus) {
                ForEach(MaritalStatus.maritalStatusList){ maritalStatus in
                    Text(maritalStatus.maritalStatus).tag(maritalStatus.maritalStatus)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct StateSelectPicker_TaxCal: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Binding var showStatePicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showStatePicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $effectiveTaxCalculator.currentState) {
                ForEach(StateNames.statesList){ state in
                    Text(state.stateName).tag(state.stateName)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct SalarySelectPicker_TaxCal: View {
    @EnvironmentObject var effectiveTaxCalculator: EffectiveTaxCalculator
    @Binding var showSalaryTypePicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showSalaryTypePicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $effectiveTaxCalculator.payGroup) {
                ForEach(PayPeriodAmount.payPeriodAmountList){ payPeriod in
                    Text(payPeriod.payPeriod).tag(payPeriod.payPeriod)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

extension SecondView_TaxCalView: EffectiveTaxCalProtocol {
    var allValuesAdded: Bool {
        effectiveTaxCalculator.payYear != "Choose One"
        && effectiveTaxCalculator.currentMaritalStatus != "Choose One"
        && effectiveTaxCalculator.currentState != "Choose One"
        && effectiveTaxCalculator.payGroup != "Choose One"
    }
}
