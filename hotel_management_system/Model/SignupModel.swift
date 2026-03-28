//
//  SignupModel.swift
//  hotel_management_system
//
//  Created by mac on 11/3/26.
//
struct SignupModel: Encodable {
    let username: String
    let email:String
    let password: String
    let first_name: String
    let last_name: String
    let phone_number: String
    let address: String
    let date_of_birth: String
}
