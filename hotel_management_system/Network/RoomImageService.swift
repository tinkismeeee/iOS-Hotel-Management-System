//
//  RoomImageService.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import Alamofire
import Foundation
class RoomImageService {
    static let shared = RoomImageService()
    private let baseURL = "https://api.unsplash.com/search/photos"
    private let params: Parameters = [
        "query": "hotel"
    ]
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
