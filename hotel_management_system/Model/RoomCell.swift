//
//  RoomCell.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import UIKit

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
}
