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
    func signUp(body: SignupModel, completion: @escaping(Result<Data?, AFError>) -> Void) {
        AF.request(SignupRouter.signUp(body: body)).validate().response {
            response in completion(response.result)
        }
    }
    func getCustomerByEmail(email: String, completion: @escaping(Result<Data?, AFError>) -> Void) {
        AF.request(ForgotPasswordRouter.getCustomerByEmail(email: email)).validate().response { response in
            completion(response.result)
        }
    }
    func updatePassword(body: UpdatePasswordModel, completion: @escaping(Result<Data?, AFError>) -> Void) {
        AF.request(ForgotPasswordRouter.updatePassword(body: body))
            .validate()
            .response { response in
                completion(response.result)
            }
    }
    func getAllPromotion(completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(PromotionRouter.getAllPromotion)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
    func getAllBooking(completion: @escaping (Result <Data?, AFError>) -> Void) {
        AF.request(BookingRouter.getAllBooking).validate().response {
            response in completion(response.result)
        }
    }
    
    func createBooking(body: BookingModel, completion: @escaping (Result <Data?, AFError>) -> Void) {
        AF.request(BookingRouter.createBooking(body: body)).validate().response { response in
            completion(response.result)
        }
    }
}

