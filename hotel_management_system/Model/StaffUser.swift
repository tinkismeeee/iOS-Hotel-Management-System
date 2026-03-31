//
//  Staff.swift
//  hotel_management_system
//
//  Created by mac on 30/3/26.
//
import Foundation

struct StaffUser: Codable {
    let user_id: Int
    let username: String
    let email: String
    let password_hash: String
    let first_name: String?
    let last_name: String?
    let phone_number: String?
    let is_active: Bool?
}
