//
//  Service.swift
//  hotel_management_system
//
//  Created by mac on 2026/3/6.
//
import Alamofire
import Foundation
class Service {
    static let shared = Service()
    private init() {}
    let baseURL = APIConfig.baseURL
    
    func login(body: LoginModel, completion: @escaping(Result<Data?, AFError>) -> Void) {
        AF.request(LoginRouter.login(body: body)).validate().response {
            response in completion(response.result)
        }
    }
    func getAllCustomers(completion: @escaping (Result<Data?, AFError>) -> Void) {
        
        AF.request(LoginRouter.getAllCustomers)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
}

