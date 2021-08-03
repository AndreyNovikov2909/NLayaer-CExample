//
//  SignUpError.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation

enum SignUpError: Error {
    case emailExist
    case invalidData
    case invalidJson
    case invalidStatusCode
    case error(message: String)
}
