//
//  CustomDesignViewModifier.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import SwiftUI

struct CustomTextDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 50)
            .background(Color.white)
    }
}

struct CustomChoiceButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .frame(width: 120, height: 50)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct CustomActionButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 30)
    }
}

struct CustomBlockDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
