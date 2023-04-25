//
//  HistoryView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI
import Charts

struct HistoryView: View {
    @State var sampleData: [MyTestData] = sample_Data
    
    //MARK: View Properties
    @State var currentTab: String = "7 Days"
    var body: some View {
        NavigationStack{
            VStack{
                //MARK: New Chart API
                Spacer()
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Text("Salary")
                            .fontWeight(.semibold)
                        Picker("", selection: $currentTab) {
                            Text("7 Days").tag("7 Days")
                            Text("Week").tag("Week")
                            Text("Month").tag("Month")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 50)
                    }
                    
                    let totalSalary = sampleData.reduce(0.0) { result, item in
                        item.salaryAfterTax + result
                    }
                    Text(totalSalary.stringFormat)
                        .font(.largeTitle.bold())
                    AnimatedCharts()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 8)))
                )
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            
            //Simple updating values for segmented tabs
            .onChange(of: currentTab) { newValue in
                sampleData = sample_Data
                if newValue != "7 Days" {
                    for (index, _) in sampleData.enumerated(){
                        sampleData[index].salaryAfterTax = .random(in: 1500...10000)
                    }
                }
                
                // Re-Animate View
                animateGraph()
            }
        }
    }
    
    @ViewBuilder
    func AnimatedCharts() -> some View {
        let max = sampleData.max { item1, item2 in
            return item2.salaryAfterTax > item1.salaryAfterTax
        }?.salaryAfterTax ?? 0.0
        
        ScrollView(.horizontal) {
            Chart{
                ForEach(sampleData){ item in
                    // BAR GRAPH
                    // Animated Graph
                    BarMark(
                        x: .value("Month", item.date, unit: .month),
                        y: .value("Salary", item.animate ? item.salaryAfterTax : 0)
                    )
                    .annotation(position: .top) {
                        Text("\(item.salaryAfterTax.stringFormat)")
                    }
                    .foregroundStyle(Color.blue.gradient)
                }
            }
            // MARK: Customize Y-Axis length
            .chartYScale(domain: 0...(max + 2000))
            .chartPlotStyle{ plotArea in
                plotArea
                    .frame(width: 650, height: 250)
                
            }
            .chartXAxis{
                AxisMarks(values: sampleData.map{ $0.date}) { date in
                    AxisValueLabel(format: .dateTime.month(), anchor: .topTrailing)
                    
                }
            }
            .onAppear {
                animateGraph()
            }
        }
    }
    
    // Animating Graph
    func animateGraph(){
        for (index, _) in sampleData.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.easeInOut(duration: 1)) {
                    sampleData[index].animate = true
                    
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}


struct MyTestData:Identifiable {
    var id = UUID().uuidString
    var date: Date
    var salaryAfterTax: Double
    var animate: Bool = false
}

var sample_Data: [MyTestData] = [
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 1, to: Date())!, salaryAfterTax: 1000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 2, to: Date())!, salaryAfterTax: 2000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 3, to: Date())!, salaryAfterTax: 3000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 4, to: Date())!, salaryAfterTax: 4000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 5, to: Date())!, salaryAfterTax: 5000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 6, to: Date())!, salaryAfterTax: 6000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 7, to: Date())!, salaryAfterTax: 5000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 8, to: Date())!, salaryAfterTax: 4000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 9, to: Date())!, salaryAfterTax: 3000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 10, to: Date())!, salaryAfterTax: 2000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 11, to: Date())!, salaryAfterTax: 1000),
    MyTestData(date: Calendar.current.date(byAdding: .month, value: 12, to: Date())!, salaryAfterTax: 1500)
    
]

extension Double {
    var stringFormat: String {
        if self >= 1000 && self < 999999 {
            return String(format: "%.1fK", self/1000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", self)
    }
}
