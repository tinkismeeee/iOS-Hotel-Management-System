import Foundation

struct Room: Codable {
    let roomId: Int
    let roomNumber: String
    let roomTypeId: Int
    let floor: Int
    let pricePerNight: String
    let maxGuests: Int
    let bedCount: Int
    let description: String
    let status: String
    let isActive: Bool
    let roomTypeName: String
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case roomNumber = "room_number"
        case roomTypeId = "room_type_id"
        case floor = "floor"
        case pricePerNight = "price_per_night"
        case maxGuests = "max_guests"
        case bedCount = "bed_count"
        case description = "description"
        case status = "status"
        case isActive = "is_active"
        case roomTypeName = "room_type_name"
    }
}
