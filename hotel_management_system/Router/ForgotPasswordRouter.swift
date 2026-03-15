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
    case updatePassword(body: UpdatePasswordModel)
    var method: HTTPMethod {
        switch self {
        case .getCustomerByEmail:
            return .get
        case .updatePassword:
            return .put
        }
    }
    var path: String {
        switch self {
        case .getCustomerByEmail(let email):
            return "/customers/email/\(email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? email)"
        case .updatePassword:
            return "/customers/update-password"
        }
    }
    var parameters: Parameters? {
        switch self {
        case .getCustomerByEmail:
            return nil
        case .updatePassword(let body):
            return [
                "email": body.email,
                "newPassword": body.newPassword
            ]
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
