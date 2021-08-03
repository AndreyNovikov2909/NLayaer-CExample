//
//  AuthApi.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation
import Combine


protocol AuthApi {
    func checkEmail(email: String) -> Future<Bool, Never>
    func signUp(username: String, email: String, password: String) -> Future<(statusCode: Int, data: Data), Error>
}
