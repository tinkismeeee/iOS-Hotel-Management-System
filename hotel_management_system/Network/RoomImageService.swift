//
//  RoomImageService.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import Alamofire
import Foundation
import UIKit

class RoomImageService {
    static let shared = RoomImageService()
    var name: [String] = ["hotel room", "bedroom", "room"]
    private let baseURL = "https://api.unsplash.com/search/photos"
    private var params: Parameters {
        return [
            "query": name.randomElement() ?? "hotel room",
            "per_page": 100
        ]
    }
    private let headers: HTTPHeaders = [
        "Accept-Version": "v1",
        "Authorization": "Client-ID 3uOtwyvGgTxcSq5xkqOfIf-JwJqqpJQD7BO-HV7_DDE"
    ]
    
    func getRoomImage(completion: @escaping (Data?) -> Void) {
        AF.request(baseURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
