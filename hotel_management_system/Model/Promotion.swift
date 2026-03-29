//
//  Promotion.swift
//  DOan
//
//  Created by DoAnhKiet on 28/03/2026.
//

import Foundation

struct Promotion: Codable {
    let promotionId: Int
    let promotionCode: String
    let name: String
    let discountValue: String
    let startDate: String
    let endDate: String
    let isActive: Bool
    let scope: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case promotionId = "promotion_id"
        case promotionCode = "promotion_code"
        case name = "name"
        case discountValue = "discount_value"
        case startDate = "start_date"
        case endDate = "end_date"
        case isActive = "is_active"
        case scope = "scope"
        case description = "description"
    }
}
