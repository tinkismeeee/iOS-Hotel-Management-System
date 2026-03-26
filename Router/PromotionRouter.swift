//
//  PromotionRouter.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 23/3/26.
//

import Foundation
import Alamofire

enum PromotionRouter: URLRequestConvertible {
    
    case getAllPromotion
    var method: HTTPMethod {
        switch self {
            case .getAllPromotion:
                return .get
        }
    }
    
    var path: String {
        switch self {
            case .getAllPromotion:
                return "/promotions"
        }
    }
    
    var parameters: Parameters? {
        switch self {
            case .getAllPromotion:
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
