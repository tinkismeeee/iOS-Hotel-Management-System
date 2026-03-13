//
//  hotel_management_system
//
//  Created by mac on 2026/3/11.
//

import Alamofire
import Foundation

enum SignupRouter: URLRequestConvertible {
    
    case signUp(body: SignupModel)
    var method: HTTPMethod {
        switch self {
            case .signUp:
                return .post
        }
    }
    
    var path: String {
        switch self {
            case .signUp:
                return "/customers"
        }
    }
    
    var parameters: Parameters? {
        switch self {
            case .signUp(let body):
                return [
                    "username": body.username,
                    "email": body.email,
                    "password": body.password,
                    "first_name": body.first_name,
                    "last_name": body.last_name,
                    "phone_number": body.phone_number,
                    "address": body.address,
                    "date_of_birth": body.date_of_birth
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
            let url = try (APIConfig.baseURL + path).asURL()
            var request = URLRequest(url: url)
            request.method = method
            request.headers = [
                "Content-Type": "application/json"
            ]   
            return try JSONEncoding.default.encode(request, with: parameters)
        }
}
