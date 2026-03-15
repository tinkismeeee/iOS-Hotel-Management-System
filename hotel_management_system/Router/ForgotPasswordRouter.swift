//
//  ForgotPassword.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import Alamofire
import Foundation

enum ForgotPasswordRouter: URLRequestConvertible {
    case getCustomerByEmail(email: String)
    var method: HTTPMethod {
        switch self {
        case .getCustomerByEmail:
            return .get
        }
    }
    var path: String {
        switch self {
        case .getCustomerByEmail(let email):
            return "/customers/email/\(email)"
        }
    }
    var parameters: Parameters? {
        switch self {
        case .getCustomerByEmail:
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
