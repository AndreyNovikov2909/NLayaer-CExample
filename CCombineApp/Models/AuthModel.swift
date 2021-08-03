//
//  AuthModel.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation

struct AuthModel: Codable {
    let name: String
    let email: String
    let password: String
    
    init(name: String = "", email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
