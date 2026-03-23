//
//  Checkout.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 23/3/26.
//

import UIKit
import Alamofire
import Kingfisher

class Checkout: UIViewController {
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var bedCount: UILabel!
    @IBOutlet weak var maxGuests: UILabel!
    @IBOutlet weak var checkInandCheckOut: UILabel!
    @IBOutlet weak var roomType: UILabel!
    @IBOutlet weak var roomNumberandFloor: UILabel!
    @IBOutlet weak var optionalServices: UILabel!
    @IBOutlet weak var promotionTextField: PromotionTextField!
    @IBOutlet weak var applyBtn: PromotionApplyButton!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var VATtax: UILabel!
    @IBOutlet weak var promotionDiscount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    var roomData: RoomModel?
    var roomImage: String? = ""
    var checkInTime: Date?
    var checkOutTime: Date?
    var optionalServicesList: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("\(roomData) | \(roomImage) | \(checkInTime) - \(checkOutTime) | \(optionalServicesList)")
        let num_formatter = NumberFormatter()
        num_formatter.numberStyle = .currency
        num_formatter.locale = Locale(identifier: "vi_VN")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone.current
        let checkInString = checkInTime.map {
            formatter.string(from: $0)
        } ?? ""
        let checkOutString = checkOutTime.map {
            formatter.string(from: $0)
        } ?? ""
        // Do any additional setup after loading the view.
        roomImg.kf.setImage(with: URL(string: roomImage ?? ""))
        roomNumberandFloor.text = "Room \(roomData?.room_number ?? "") - Floor \(roomData?.floor ?? 0)"
        roomType.text = "Room type: \(roomData?.room_type_name ?? "")"
        maxGuests.text = "Max number of guests: \(roomData?.max_guests ?? 0)"
        bedCount.text = "Max number of beds: \(roomData?.bed_count ?? 0)"
        checkInandCheckOut.text = "\(checkInString) - \(checkOutString)"
        optionalServices.text = optionalServicesList?.joined(separator: ", ")
        if let checkIn = checkInTime,
           let checkOut = checkOutTime,
           let priceStr = roomData?.price_per_night,
           let pricePerNight = Double(priceStr) {
            let calendar = Calendar.current
            let nights = max(1, calendar.dateComponents([.day], from: checkIn, to: checkOut).day ?? 1)
            let total = Double(nights) * pricePerNight
            let numFormatter = NumberFormatter()
            numFormatter.numberStyle = .currency
            numFormatter.locale = Locale(identifier: "vi_VN")
            numFormatter.minimumFractionDigits = 0
            numFormatter.maximumFractionDigits = 0
            let vat = total * 0.1
            VATtax.text = numFormatter.string(from: NSNumber(value: vat))
            roomPrice.text = numFormatter.string(from: NSNumber(value: total))
            
        }
    }
    
    @IBAction func confirmPayment(_ sender: Any) {
    }
}
