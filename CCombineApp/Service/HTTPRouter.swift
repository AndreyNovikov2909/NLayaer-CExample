//
//  HTTPRouter.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Alamofire

protocol HttpRouter: URLRequestConvertible {
    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func body() throws -> Data?
    func request(usingHttpService httpService: HttpService) throws -> DataRequest
}


extension HttpRouter {
    func request(usingHttpService httpService: HttpService) throws -> DataRequest {
        return try httpService.request(asURLRequest())
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url = url.appendingPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
}
