//
//  BookingHistoryModel.swift
//  hotel_management_system
//
//  Created by mac on 28/3/26.
//

import Foundation
import UIKit

struct BookingHistoryModel: Codable {
    var booking_id: Int?
    var user_id: Int?
    var booking_date: String?
    var check_in: String?
    var check_out: String?
    var status: String?
    var total_guests: Int?
    var promotion_id: String?
    var number_of_days: Int?
    var number_of_nights: Int?
    var total_price: String?
    var username: String?
}
