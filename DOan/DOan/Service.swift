import Foundation

struct Service: Codable {
    let serviceId: Int
    let serviceCode: String
    let name: String
    let price: String
    let availability: Bool
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case serviceId = "service_id"
        case serviceCode = "service_code"
        case name = "name"
        case price = "price"
        case availability = "availability"
        case description = "description"
    }
}
