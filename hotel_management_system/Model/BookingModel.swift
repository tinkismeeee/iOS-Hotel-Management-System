//
//  BookingModel.swift
//  hotel_management_system
//
//  Created by mac on 28/3/26.
//
import Foundation
import UIKit
struct BookingModel: Codable {
    var user_id: Int
    var check_in: Date
    var check_out: Date
    var total_guests: Int
    var total_price: Double
    var room_id: [Int]
}
