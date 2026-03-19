//
//  RoomCell.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import UIKit
import Foundation

class RoomCell: UITableViewCell {
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomBedCount: UILabel!
    @IBOutlet weak var roomMaxGuests: UILabel!
    @IBOutlet weak var roomServices: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var roomType: UILabel!
    @IBOutlet weak var roomFloor: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
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
        roomImage.layer.cornerRadius = 15
    }
}
