//
//  AuthParserService.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation
import Combine

protocol AuthServiceParsebtable {
    func parseSignUpResponse(statusCode: Int, data: Data) -> AnyPublisher<AuthResult<TokenResponseModel>, Error>
}

class AuthParserService {
    static let shared = AuthParserService()
    
    private init() {}
}


// MARK: - AuthServiceParsebtable

extension AuthParserService: AuthServiceParsebtable {
    func parseSignUpResponse(statusCode: Int, data: Data) -> AnyPublisher<AuthResult<TokenResponseModel>, Error> {
        return Just((statusCode: statusCode, data: data))
            .tryMap { (args) -> AuthResult<TokenResponseModel> in
                guard args.statusCode == 200 else {
                    do {
                        let authError = try JSONDecoder().decode(SignUpErrorModel.self, from: data)
                        
                        if let nameError = authError.validationErrors.naame?.first {
                            return .failuree(SignUpError.error(message: nameError))
                        }
                        
                        if let emailError = authError.validationErrors.email?.first {
                            return .failuree(SignUpError.error(message: emailError))
                        }
                        
                        if let passwordError = authError.validationErrors.password?.first {
                            return .failuree(SignUpError.error(message: passwordError))
                        }
                        
                        return .failuree(SignUpError.error(message: "Unowned error"))
                    } catch {
                        return .failuree(error)
                    }
                }
                
                guard let tokenResponsebleModel = try? JSONDecoder().decode(TokenResponseModel.self, from: data) else {
                    return .failuree(SignUpError.invalidJson)
                }
                
                return .success(tokenResponsebleModel)
            }.eraseToAnyPublisher()
    }
}
