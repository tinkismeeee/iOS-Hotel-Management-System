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
    var promotions: [PromotionModel] = []
    var promotionCodes: [String] = []
    let applyFailedAlert = UIAlertController(title: "Error", message: "Promotion code is invalid or empty", preferredStyle: .alert)
    let applySuccessfullyAlert = UIAlertController(title: "Successfully", message: "Use voucher successfully", preferredStyle: .alert)
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
        var room_price = 0.0
        var vat_price = 0.0
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
            room_price = total
            vat_price = vat
        }
        promotionDiscount.text = num_formatter.string(from: NSNumber(value: 0))
        totalPrice.text = num_formatter.string(from: NSNumber(value: vat_price + room_price))
        Service.shared.getAllPromotion { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let promos = try JSONDecoder().decode([PromotionModel].self, from: data)
                        self.promotions = promos.filter { $0.is_active }
                        self.promotionCodes = self.promotions.map { $0.promotion_code }
                    } catch {
                        print("Decode error:", error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        applyFailedAlert.addAction(okAction)
        applySuccessfullyAlert.addAction(okAction)
    }
    
    @IBAction func applyPromotion(_ sender: Any) {
        let promotionCode = promotionTextField.text ?? ""
        if (promotionCode.isEmpty) {
            present(applyFailedAlert, animated: true)
            return
        }
        if (promotionCodes.contains(promotionCode)) {
            let calendar = Calendar.current
            let nights = max(1, calendar.dateComponents([.day], from: checkInTime!, to: checkOutTime!).day ?? 1)
            let roomTotal = Double(nights) * Double(roomData?.price_per_night ?? "0")!
            let optionalServiceTotal = 0.0
            
            var discountPercent = 0.0
            if let index = promotions.firstIndex(where: {$0.promotion_code == promotionCode}) {
                discountPercent = Double(promotions[index].discount_value) ?? 0
                print(discountPercent)
            }
            
            
            let discount = (roomTotal + optionalServiceTotal) * discountPercent / 100
            let numFormatter = NumberFormatter()
            numFormatter.numberStyle = .currency
            numFormatter.locale = Locale(identifier: "vi_VN")
            numFormatter.minimumFractionDigits = 0
            numFormatter.maximumFractionDigits = 0
            
            promotionDiscount.text = numFormatter.string(from: NSNumber(value: discount))
            
            let vat = (roomTotal + optionalServiceTotal - discount) * 0.1
            VATtax.text = numFormatter.string(from: NSNumber(value: vat))
            
            let total = roomTotal + optionalServiceTotal - discount + vat
            totalPrice.text = numFormatter.string(from: NSNumber(value: total))
            
            present(applySuccessfullyAlert, animated: true)
//            promotionTextField.isEnabled = false
//            applyBtn.isEnabled = false
        }
        else {
            present(applyFailedAlert, animated: true)
            promotionTextField.text = ""
        }
    }
    @IBAction func confirmPayment(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "qrcode") as! QRcode
        // print(navigationController)
        navigationController?.pushViewController(vc, animated: true)
    }
}
