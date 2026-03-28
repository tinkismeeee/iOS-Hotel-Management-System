//
//  OTPService.swift
//  hotel_management_system
//
//  Created by mac on 14/3/26.
//

import Foundation
import Alamofire

class OtpService {
    static let shared = OtpService()
    private let baseUrl = "http://38.242.228.108:3001"
    func sendOtp(email: String, callback: @escaping (Bool, String) -> Void) {
        let url = "\(baseUrl)/send-otp"
        let params: [String: String] = ["email": email]
        AF.request(url, method: .post, parameters: params, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            switch response.result {
            case .success(let result):
                callback(true, result)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
    }

    func verifyOtp(email: String, otp: String, callback: @escaping (Bool, String) -> Void) {
        let url = "\(baseUrl)/verify-otp"
        let params: [String: String] = [
            "email": email,
            "otp": otp
        ]
        AF.request(url, method: .post, parameters: params, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            switch response.result {
            case .success(let result):
                let success = result.contains("\"success\":true")
                callback(success, result)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
    }
}
