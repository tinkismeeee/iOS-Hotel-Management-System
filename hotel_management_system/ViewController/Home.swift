//
//  Home.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation

class Home: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImage: CircleAvatar!
    @IBOutlet weak var notification: Icon!
    @IBOutlet weak var addressHolder: UILabel!
    @IBOutlet weak var nameHolder: UILabel!
    @IBOutlet weak var bookingHistory: UIImageView!
    @IBOutlet weak var test: UILabel!
    var filteredRooms: [RoomModel] = []
    var rooms: [RoomModel] = []
    var roomImageUrls: [String] = []
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        avatarImage.isUserInteractionEnabled = true
        bookingHistory.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
        avatarImage.addGestureRecognizer(tap)
        let bookingHistoryTap = UITapGestureRecognizer(target: self, action: #selector(Bkhistory))
        bookingHistory.addGestureRecognizer(bookingHistoryTap)
        loadRooms()
        loadRoomImages()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       
        let firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
        let lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
        nameHolder.text = firstName + " " + lastName
        addressHolder.text = UserDefaults.standard.string(forKey: "address")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func loadRoomImages() {
        roomImageUrls.removeAll()
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
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
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
                self.filteredRooms = rooms
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let place = placemarks?.first else { return }
            let city = place.locality ?? ""
            let country = place.country ?? ""
            DispatchQueue.main.async {
                self.addressHolder.text = "\(city), \(country)"
            }
        }
    }
    
    @objc func getLocation() {
        locationManager.startUpdatingLocation()
    }
    
    @objc func changeAvatar() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func Bkhistory() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BookingHistory") as! BookingHistory
        navigationController?.pushViewController(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatarImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func filterRooms(type: String) {
        filteredRooms = rooms.filter { $0.room_type_name == type }
        loadRoomImages()
        tableView.reloadData()
    }
    
    @IBAction func standardBtn(_ sender: Any) {
        filterRooms(type: "Standard")
    }
    
    @IBAction func familyBtn(_ sender: Any) {
        filterRooms(type: "Family")
    }
    
    @IBAction func deluxeBtn(_ sender: Any) {
        filterRooms(type: "Deluxe")
    }
    @IBAction func businessBtn(_ sender: Any) {
        filterRooms(type: "Business")
    }
    
}
extension Home: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = filteredRooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        if indexPath.row < roomImageUrls.count {
            let urlString = roomImageUrls[indexPath.row % roomImageUrls.count]
            cell.roomImage.kf.setImage(with: URL(string: urlString))
        }
        cell.roomNumber.text = "Room number: \(room.room_number)"
        cell.roomFloor.text = "Floor \(room.floor)"
        cell.roomType.text = "Type: \(room.room_type_name)"
        cell.roomMaxGuests.text = "Max guests: \(room.max_guests)"
        cell.roomBedCount.text = "Bed count: \(room.bed_count)"
        cell.roomDescription.text = "\(room.description)"
        cell.roomPrice.text = "Price: \(room.price_per_night) VND/night"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = filteredRooms[indexPath.row]
        print(room)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RoomDetail") as! RoomDetail
        vc.room = room
        vc.roomImage = roomImageUrls[indexPath.row % roomImageUrls.count]
        // print(navigationController)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
