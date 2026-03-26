//
//  PaymentDetailModel.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 26/3/26.
//

import Foundation
import UIKit
struct PaymentDetailModel: Codable {
    var total: Double?
    var room: RoomModel?
    var checkIn: Date?
    var checkOut: Date?
    var services: [String]?
}

