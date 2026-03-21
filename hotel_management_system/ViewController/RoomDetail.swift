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
    enum Service: String {
        case laundry
        case spa
        case taxi
        case breakfast
        case minibar
        case dinner
    }
    var selectedServices: [Service] = []
    @IBOutlet weak var roomFloor: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomType: UILabel!
    @IBOutlet weak var bedCount: UILabel!
    @IBOutlet weak var maxGuests: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var checkin: UIDatePicker!
    @IBOutlet weak var checkout: UIDatePicker!
    
    @IBOutlet weak var laundry: UIButton!
    @IBOutlet weak var spa: UIButton!
    @IBOutlet weak var taxi: UIButton!
    @IBOutlet weak var breakfast: UIButton!
    @IBOutlet weak var minibar: UIButton!
    @IBOutlet weak var dinner: UIButton!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let urlString = roomImage {
            ImageCache.default.removeImage(forKey: urlString)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        roomNumber.text = "Room: \(room?.room_number ?? "")"
        roomFloor.text = "Floor: \(room?.floor ?? 0)"
        roomType.text = room?.room_type_name
        maxGuests.text = "\(room?.max_guests ?? 0)"
        bedCount.text = "\(room?.bed_count ?? 0)"
        roomDescription.text = room?.description
        roomImg.kf.setImage(with: URL(string: roomImage ?? ""))
        roomImg.layer.cornerRadius = 12
        roomImg.clipsToBounds = true
        addRGBBorder()
    
    }
    func addRGBBorder() {
        let gradient = CAGradientLayer()
        gradient.frame = roomImg.bounds
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor,
            UIColor.red.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let shape = CAShapeLayer()
        shape.lineWidth = 3
        shape.path = UIBezierPath(
            roundedRect: roomImg.bounds,
            cornerRadius: 12
        ).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        gradient.mask = shape
        
        roomImg.layer.addSublayer(gradient)
    }
    @IBAction func serviceSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let service = serviceFromButton(sender) else {
            return
        }
        if sender.isSelected {
            sender.backgroundColor = .button
            sender.setTitleColor(.background, for: .normal)
            selectedServices.append(service)
        }
        else {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            selectedServices.removeAll { $0 == service }
        }
        print(selectedServices)
    }
    func serviceFromButton(_ button: UIButton) -> Service? {
        switch button {
            case laundry:
                return .laundry
            case spa:
                return .spa
            case taxi:
                return .taxi
            case breakfast:
                return .breakfast
            case minibar:
                return .minibar
            case dinner:
                return .dinner
            default:
                return nil
        }
    }
}
