//
//  IntroView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct IntroView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @AppStorage("signed_in") var userSignedIn: Bool = false
    
    var body: some View {
        ZStack{
            if userSignedIn {
                MainView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            IntroView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
        .environmentObject(AuthViewModel())
    }
}
