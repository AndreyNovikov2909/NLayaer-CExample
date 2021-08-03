//
//  AuthTextField.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/17/21.
//

import SwiftUI

struct AuthTetxField: View {
    @Binding var textValue: String
    var errorValue: String
    var title: String
    var keyboardType: UIKeyboardType
    var isSecured = false

    
    var body: some View {
        VStack {
            
            if isSecured {
                SecureField(title, text: $textValue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .keyboardType(keyboardType)
            } else {
                TextField(title, text: $textValue)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(5)
                    .keyboardType(keyboardType)
            }
            
            Text(errorValue)
                .fontWeight(.light)
                .foregroundColor(.red)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .trailing)
        }
    }
}
