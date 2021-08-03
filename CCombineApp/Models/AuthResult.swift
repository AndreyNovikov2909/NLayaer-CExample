//
//  AuthResult.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation

enum AuthResult<T> {
    case success(T)
    case failuree(Error)
}
