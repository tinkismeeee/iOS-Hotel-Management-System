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
    case createBooking(body: BookingModel)
    var method: HTTPMethod {
        switch self {
        case .getAllBooking:
            return .get
        case .createBooking:
            return .post
        }
    }

    var path: String {
        switch self {
        case.getAllBooking:
            return "/bookings"
        case .createBooking:
            return "/bookings"
        }
    }
    var parameters: Parameters? {
        switch self {
        case .getAllBooking:
            return nil
        case .createBooking(let body):
            return [
                "user_id": body.user_id,
                "check_in": body.check_in,
                "check_out": body.check_out,
                "total_guests": body.total_guests,
                "room_ids": body.room_id,
                "total_price": body.total_price
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
