//
//  RoomModel.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//
struct RoomModel: Codable {
    let room_id: Int
    let room_number: String
    let room_type_id: Int
    let floor: Int
    let price_per_night: String
    let max_guests: Int
    let bed_count: Int
    let description: String
    let status: String
    let is_active: Bool
    let room_type_name: String
}
