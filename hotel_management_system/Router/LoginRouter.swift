//
//  Login-r.swift
//  hotel_management_system
//
//  Created by mac on 2026/3/10.
//

import Alamofire
import Foundation

enum LoginRouter: URLRequestConvertible {
    
    case login(body: LoginModel)
    case getAllCustomers
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getAllCustomers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/customers/login"
        case .getAllCustomers:
            return "/customers"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let body):
            return [
                "email": body.email,
                "password": body.password
            ]
        case .getAllCustomers:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseURL = APIConfig.baseURL
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        switch method {
        case .get:
            return try URLEncoding.default.encode(request, with: parameters)
        default:
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
}
