//
//  UpdatePasswordModel.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//
import Foundation
struct UpdatePasswordModel: Encodable {
    let email: String
    let newPassword: String
}
