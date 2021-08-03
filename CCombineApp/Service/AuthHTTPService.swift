//
//  AuthHTTPService.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Alamofire

final class AuthHttpService: HttpService {
    var session: Session = Session.default
    
    func request(_ urlRequesst: URLRequestConvertible) -> DataRequest {
        return session.request(urlRequesst).validate(statusCode: 200..<400)
    }
}
