import Foundation

struct Invoice: Codable {
    let invoiceId: Int
    let bookingId: Int
    let staffId: Int
    let issueDate: String
    let totalRoomCost: String
    let totalServiceCost: String
    let discountAmount: String
    let finalAmount: String
    let vatAmount: String
    let paymentMethod: String
    let paymentStatus: String
    
    enum CodingKeys: String, CodingKey {
        case invoiceId = "invoice_id"
        case bookingId = "booking_id"
        case staffId = "staff_id"
        case issueDate = "issue_date"
        case totalRoomCost = "total_room_cost"
        case totalServiceCost = "total_service_cost"
        case discountAmount = "discount_amount"
        case finalAmount = "final_amount"
        case vatAmount = "vat_amount"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
    }
}
