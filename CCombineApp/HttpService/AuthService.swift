//
//  AuthService.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation
import Alamofire
import Combine

class AuthService {
    static let shared = AuthService()
    lazy var httpService = AuthHttpService()
    
    private init() {}
}


// MARK: - Auth Api

extension AuthService: AuthApi {
    func checkEmail(email: String) -> Future<Bool, Never> {
        return Future { [httpService] (promise) in
            do {
                try AuthRouter
                    .validate(email: email)
                    .request(usingHttpService: httpService)
                    .responseJSON { (response) in
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            promise(.success(true))
                        } else {
                            promise(.success(false))
                        }
                    }
            } catch {
                promise(.success(false))
            }
        }
    }
    
    func signUp(username: String, email: String, password: String) -> Future<(statusCode: Int, data: Data), Error> {
        let authModel = AuthModel(name: username, email: email, password: password)
        
        return Future { [httpService] (promise) in
            do {
                try AuthRouter
                    .signUp(authModel)
                    .request(usingHttpService: httpService)
                    .responseJSON { (response) in
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            promise(.failure(SignUpError.invalidData))
                            return
                        }
                        
                        promise(.success((statusCode: statusCode, data: data)))
                    }
                
            } catch {
                promise(.failure(error))
            }
        }
    }
}
