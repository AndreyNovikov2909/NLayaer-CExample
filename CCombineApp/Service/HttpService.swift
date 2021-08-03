//
//  HttpService.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/18/21.
//

import Alamofire

protocol HttpService {
    var session: Session { get set }
    func request(_ urlRequesst: URLRequestConvertible) -> DataRequest
}
