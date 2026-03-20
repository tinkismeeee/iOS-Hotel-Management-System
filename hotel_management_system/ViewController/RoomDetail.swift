//
//  RoomDetail.swift
//  hotel_management_system
//
//  Created by mac on 19/3/26.
//

import UIKit
import Kingfisher
class RoomDetail: UIViewController {
    var room: RoomModel?
    var roomImage: String?
    
    @IBOutlet weak var roomFloor: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomType: UILabel!
    @IBOutlet weak var bedCount: UILabel!
    @IBOutlet weak var maxGuests: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var checkin: UIDatePicker!
    @IBOutlet weak var checkout: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("\(room)\n\(roomImage)")
        // Do any additional setup after loading the view.
        roomNumber.text = "Room: \(room?.room_number ?? "")"
        roomFloor.text = "Floor: \(room?.floor ?? 0)"
        roomType.text = room?.room_type_name
        maxGuests.text = "\(room?.max_guests ?? 0)"
        bedCount.text = "\(room?.bed_count ?? 0)"
        roomDescription.text = room?.description
        roomImg.kf.setImage(with: URL(string: roomImage ?? ""))
    }

}
