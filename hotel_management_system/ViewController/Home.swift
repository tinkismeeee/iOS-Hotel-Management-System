//
//  Home.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import UIKit

class Home: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImage: CircleAvatar!
    @IBOutlet weak var notification: Icon!
    @IBOutlet weak var location2: UIImageView!
    @IBOutlet weak var location1: UIImageView!
    @IBOutlet weak var addressHolder: UILabel!
    @IBOutlet weak var nameHolder: UILabel!
    
    var rooms: [RoomModel] = []
    var roomImageUrls: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        avatarImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
        avatarImage.addGestureRecognizer(tap)
        loadRooms()
        RoomImageService.shared.getRoomImage { data in
            guard let data = data else {
                print("Get room images failed")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let results = json["results"] as? [[String: Any]] {
                        for item in results {
                            if let urls = item["urls"] as? [String: Any], let regular = urls["regular"] as? String {
                                self.roomImageUrls.append(regular)
                            }
                        }
//                        DispatchQueue.main.async {
//                            print(self.roomImageUrls)
//                        }
                    }
                }
            } catch {
                print("JSON parse error:", error)
            }
        }
    }
    
    func loadRooms() {
        RoomService.fetchRooms { rooms in
            DispatchQueue.main.async {
                self.rooms = rooms
                self.tableView.reloadData()
            }
        }
    }

    @objc func changeAvatar() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatarImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
}
extension Home: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        cell.roomNumber.text = "Room number: \(room.room_number)"
        cell.roomFloor.text = "Floor \(room.floor)"
        cell.roomType.text = "Type: \(room.room_type_name)"
        cell.roomMaxGuests.text = "Max guests: \(room.max_guests)"
        cell.roomBedCount.text = "Bed count: \(room.bed_count)"
        cell.roomDescription.text = "\(room.description)"
        cell.roomPrice.text = "Price: \(room.price_per_night) VND/night"
        return cell
    }
}
