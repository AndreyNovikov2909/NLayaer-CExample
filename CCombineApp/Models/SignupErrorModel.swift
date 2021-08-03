//
//  SignupErrorModel.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation

struct SignUpErrorModel: Codable {
    let validationErrors: ValidatioonErrors
    
    enum CodingKeys: String, CodingKey {
        case validationErrors = "validation_errors"
    }
}

struct ValidatioonErrors: Codable {
    let naame, email, password: [String]?
}
