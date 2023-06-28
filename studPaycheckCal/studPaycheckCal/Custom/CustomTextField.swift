//
//  CustomTextField.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 6/24/23.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
            }
            .frame(height: 2)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant(""), title: "Title", placeholder: "hint")
    }
}
