//
//  AuthHTTPRouter.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Alamofire

enum AuthRouter {
    case signUp(AuthModel)
    case validate(email: String)
}


extension AuthRouter: HttpRouter {
    var baseUrlString: String {
        return "https://letscodeeasy.com/groceryapi/[ublic/api"
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "register"
        case .validate:
            return "validate/email"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .validate:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp, .validate:
            return ["Content-Type": "application/jsson; charset=UTF-8"]
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    
    // MARK: - Methods
        
    func body() throws -> Data? {
        switch self {
        case .signUp(let authModel):
            return try JSONEncoder().encode(authModel)
        case .validate(email: let email):
            return try JSONEncoder().encode(["email": email])
        }
    }
}
