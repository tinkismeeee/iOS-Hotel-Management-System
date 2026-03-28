//
//  RoomDetailViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class RoomDetailViewController: UIViewController {

    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var roomData: Room?
    override func viewDidLoad() {
            super.viewDidLoad()

            if let room = roomData {
                // Chỉ để hiển thị mỗi số phòng (VD: "Phòng 101")
                roomNameLabel.text = "Phòng \(room.roomNumber)"
                
                // Gán tên loại phòng vào Label mới tạo (VD: "Loại phòng: Family")
                roomTypeLabel.text = "\(room.roomTypeName)"
                
                descriptionLabel.text = " \(room.description)"
                floorLabel.text = "\(room.floor)"
                statusLabel.text = " \(room.status.uppercased())"
                guestLabel.text = "\(room.maxGuests) người"
                bedLabel.text = "\(room.bedCount) giường"
                
                // Xử lý làm đẹp giá tiền
                if let priceDouble = Double(room.pricePerNight) {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let formattedPrice = formatter.string(from: NSNumber(value: priceDouble)) ?? room.pricePerNight
                    priceLabel.text = " \(formattedPrice) VNĐ/đêm"
                } else {
                    priceLabel.text = " \(room.pricePerNight) VNĐ/đêm"
                }
            }
        }		
    



}
