//
//  ContentView.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/17/21.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject private var viewModel: SignUpViewModel
    
    // MARK: - Init
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Green grocency")
                    .font(Font.custom("Noteworthy-Bold", size: 40))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                
                AuthTetxField(textValue: $viewModel.username,
                              errorValue: viewModel.usernameError,
                              title: "Username",
                              keyboardType: .default)
                
                
                AuthTetxField(textValue: $viewModel.email,
                              errorValue: viewModel.emailError,
                              title: "Email",
                              keyboardType: .emailAddress)
                
                AuthTetxField(textValue: $viewModel.password,
                              errorValue: viewModel.passworddError,
                              title: "Password",
                              keyboardType: .default,
                              isSecured: true)
                
                AuthTetxField(textValue: $viewModel.confirmPassword,
                              errorValue: viewModel.confirmPassswordError,
                              title: "Confirm password",
                              keyboardType: .default,
                              isSecured: true)
                
                Button(action: viewModel.signUp, label: {
                    Text("Sign Up")
                })
                .disabled(!viewModel.enableSignUp)
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding()
                .background(viewModel.enableSignUp ? Color.black : Color.gray)
                .cornerRadius(10)
                .padding(.top, 20)
                
                Text(viewModel.statusViewModel.title)
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .foregroundColor(viewModel.statusViewModel.color.color())
            }
            .padding(40)
        }
    }
}
