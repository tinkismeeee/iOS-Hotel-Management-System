//
//  PaymentDetailModel.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 26/3/26.
//

import Foundation
import UIKit
struct PaymentDetailModel: Codable {
    let total: String
    let room: RoomModel
    let checkIn: Date
    let checkOut: Date
    let services: [String]
}

