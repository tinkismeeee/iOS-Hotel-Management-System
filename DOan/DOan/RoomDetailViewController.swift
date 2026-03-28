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
                roomTypeLabel.text = "Loại phòng: \(room.roomTypeName)"
                
                descriptionLabel.text = "Mô tả: \(room.description)"
                floorLabel.text = "Tầng: \(room.floor)"
                statusLabel.text = "Trạng thái: \(room.status.uppercased())"
                guestLabel.text = "Số khách tối đa: \(room.maxGuests) người"
                bedLabel.text = "Số giường: \(room.bedCount) giường"
                
                // Xử lý làm đẹp giá tiền
                if let priceDouble = Double(room.pricePerNight) {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let formattedPrice = formatter.string(from: NSNumber(value: priceDouble)) ?? room.pricePerNight
                    priceLabel.text = "Giá: \(formattedPrice) VNĐ/đêm"
                } else {
                    priceLabel.text = "Giá: \(room.pricePerNight) VNĐ/đêm"
                }
            }
        }		
    



}
