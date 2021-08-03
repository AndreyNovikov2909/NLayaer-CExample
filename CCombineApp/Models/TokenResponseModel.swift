//
//  TokenResponseModel.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Foundation

struct TokenResponseModel: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
