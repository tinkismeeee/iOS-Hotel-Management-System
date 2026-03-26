//
//  PromotionModel.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 23/3/26.
//
import Foundation

struct PromotionModel: Codable {
    let promotion_id: Int
    let promotion_code: String
    let name: String
    let discount_value: String
    let start_date: String
    let end_date: String
    let is_active: Bool
    let scope: String
    let description: String?
    var discountAmount: Double {
        return Double(discount_value) ?? 0
    }
}
