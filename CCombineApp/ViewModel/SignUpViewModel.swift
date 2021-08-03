//
//  SignUpViewModel.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/17/21.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    
    // MARK: - Published
    
    @Published var statusViewModel: StatusViewModel = StatusViewModel(title: "", color: .success)
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var usernameError = ""
    @Published var emailError: String = ""
    @Published var passworddError = ""
    @Published var confirmPassswordError = ""
    @Published var enableSignUp: Bool = false
    
    // MARK: - Publisher validation
    
    private var usernameValidPublisher: AnyPublisher<Bool, Never> {
        return $username
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var emailRequredPublisher: AnyPublisher<(email: String, isValid: Bool), Never> {
       return $email
        .map { (email: $0, isValid: !$0.isEmpty) }
        .eraseToAnyPublisher()
    }
    
    private var emailValidaPublisher: AnyPublisher<(email: String, isValid: Bool), Never> {
        return emailRequredPublisher
            .filter { $0.isValid }
            .map { (email: $0.email, isValid: $0.email.isValidEmail()) }
            .eraseToAnyPublisher()
    }
    
    private var passwordRequredPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return $password
            .map { (password: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    private var passwordValidPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return passwordRequredPublisher
            .filter { $0.isValid }
            .map { (password: $0.password, isValid: $0.password.isValidPassword()) }
            .eraseToAnyPublisher()
    }
    
    private var confirmPasswordRequredPublisher: AnyPublisher<(confirmPasswod: String, isValid: Bool), Never> {
        return $confirmPassword
            .map { (confirmPasswod: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    private var confirmPasswordEqualValidPublisher: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($password, $confirmPassword)
            .map { password, confirmPassword in
                return password.isValidPassword() && confirmPassword.isValidPassword() && password == confirmPassword
            }
            .eraseToAnyPublisher()
    }
    
    private var emailServerValidPublisher: AnyPublisher<Bool, Never> {
        return emailValidaPublisher
            .filter {$0.isValid }
            .map { $0.email }
            .debounce(for: 0.33, scheduler: RunLoop.main)
            .flatMap { [authAPI] in authAPI.checkEmail(email: $0) }
            // for testing
            .map { !$0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private var cancelableBag = Set<AnyCancellable>()

    // MARK: - Services
    
    private let authAPI: AuthApi
    private let authParser: AuthServiceParsebtable
    
    // MARK: - Instance methods
    
    func signUp() {
        authAPI
            .signUp(username: username, email: email, password: password)
            .flatMap { [authParser] in
                authParser.parseSignUpResponse(statusCode: $0.statusCode, data: $0.data)
            }
            .map { ressult -> StatusViewModel in
                switch ressult {
                case .success(_):
                    return StatusViewModel(title: "SignUp successfuly", color: .success)
                case .failuree(let error):
                    return StatusViewModel(title: "Signup failure, error \(error.localizedDescription)", color: .failure)
                }
            }
            .receive(on: RunLoop.main)
            .replaceError(with: StatusViewModel(title: "Signup failure", color: .failure))
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.username = ""
                self?.email = ""
                self?.password = ""
                self?.confirmPassword = ""
            })
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancelableBag)
    }
    
    // MARK: - Object livecyccle
    
    init(authAPI: AuthApi, authParser: AuthServiceParsebtable) {
        self.authAPI = authAPI
        self.authParser = authParser
        
        validationProcess()
    }
    
    deinit {
        cancelableBag.removeAll()
    }
}


// MARK: - Process

private extension SignUpViewModel {
    func validationProcess() {
        // username validation
        
        /// empty validation
        usernameValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0 ? "" : "Username is missign" }
            .assign(to: \.usernameError, on: self)
            .store(in: &cancelableBag)
    
        // email validation
        
        /// emapty validation
        emailRequredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Email is missing" }
            .assign(to: \.emailError, on: self)
            .store(in: &cancelableBag)
        
        /// email regex validation
        emailValidaPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Email is missing" }
            .assign(to: \.emailError, on: self)
            .store(in: &cancelableBag)
        
        // password
        
        /// empty validation
        passwordRequredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Password is missing" }
            .assign(to: \.passworddError, on: self)
            .store(in: &cancelableBag)
        
        /// password regex validation
        passwordValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Password must be 8 characters with 1 aplhabet and 1 number" }
            .assign(to: \.passworddError, on: self)
            .store(in: &cancelableBag)
    
        // confirm password
    
        /// empty validation
        confirmPasswordRequredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Confirm password is missing" }
            .assign(to: \.confirmPassswordError, on: self)
            .store(in: &cancelableBag)
        /// password is same
        confirmPasswordEqualValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0 ? "" : "Passwords are not same" }
            .assign(to: \.confirmPassswordError, on: self)
            .store(in: &cancelableBag)
        
        /// email is valid
        emailServerValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0 ? "" : "Email already is used" }
            .assign(to: \.emailError, on: self)
            .store(in: &cancelableBag)
        
        /// enaable sign up button
        
        Publishers.CombineLatest4(usernameValidPublisher,
                                  emailServerValidPublisher,
                                  passwordValidPublisher,
                                  confirmPasswordEqualValidPublisher)
            .map { (value) -> Bool in
                return value.0 && value.1 && value.2.isValid && value.3
            }
            .receive(on: RunLoop.main)
            .assign(to: \.enableSignUp, on: self)
            .store(in: &cancelableBag)
    }
}
