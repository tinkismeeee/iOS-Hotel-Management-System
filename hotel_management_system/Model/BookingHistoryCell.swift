//
//  BookingHistoryCell.swift
//  hotel_management_system
//
//  Created by mac on 28/3/26.
//

import UIKit
import Foundation

class BookingHistoryCell : UITableViewCell {
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var checkinAndCheckoutTime: UILabel!
    @IBOutlet weak var bookingId: UILabel!
    @IBOutlet weak var ViewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewCell.layer.borderWidth = 1.5
        ViewCell.layer.borderColor = UIColor.lightGray.cgColor
        ViewCell.layer.cornerRadius = 15
        ViewCell.layer.shadowColor = UIColor.black.cgColor
        ViewCell.layer.shadowOpacity = 0.1
        ViewCell.layer.shadowOffset = CGSize(width: 0, height: 3)
        ViewCell.layer.shadowRadius = 6
        roomImage.layer.cornerRadius = 10
    }
}
