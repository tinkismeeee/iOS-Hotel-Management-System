//
//  BookingRouter.swift
//  hotel_management_system
//
//  Created by mac on 28/3/26.
//

import Alamofire
import Foundation

enum BookingRouter: URLRequestConvertible {
    case getAllBooking
    var method: HTTPMethod {
        switch self {
        case .getAllBooking:
                return .get
        }
    }
    var path: String {
        switch self {
        case.getAllBooking:
            return "/bookings"
        }
    }
    var parameters: Parameters? {
        switch self {
        case .getAllBooking:
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
