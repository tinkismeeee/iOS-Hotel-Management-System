import UIKit

// MARK: - 1. MODEL
struct Room: Codable {
    var room_id: Int?
    var room_number: String
    var room_type_id: Int?
    var floor: Int
    var price_per_night: String
    var max_guests: Int
    var bed_count: Int
    var description: String
    var status: String
    var is_active: Bool?
    var room_type_name: String
}

// MARK: - 2. CUSTOM CELL
class RoomCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
}

// MARK: - 3. DANH SÁCH (RoomListViewController)
class RoomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var rooms: [Room] = []
    let apiURL = "http://38.242.228.108:5000/api/rooms"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: apiURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode([Room].self, from: data) {
                DispatchQueue.main.async { self.rooms = decoded; self.tableView.reloadData() }
            }
        }.resume()
    }
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
            // Chuyển đổi trạng thái chỉnh sửa
            let isEditing = !tableView.isEditing
            tableView.setEditing(isEditing, animated: true)
            
            // Thay đổi icon hoặc tiêu đề nút tùy ý
            sender.title = isEditing ? "Xong" : "Sửa"
        }

        // 2. CHO PHÉP CHẾ ĐỘ XÓA
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let roomToDelete = rooms[indexPath.row]
                
                // Gọi API xóa
                deleteRoomFromAPI(id: roomToDelete.room_id!) {
                    DispatchQueue.main.async {
                        self.rooms.remove(at: indexPath.row) // Xóa trong mảng
                        tableView.deleteRows(at: [indexPath], with: .fade) // Xóa trên giao diện
                    }
                }
            }
        }

        // 3. HÀM GỌI API XÓA
        func deleteRoomFromAPI(id: Int, completion: @escaping () -> Void) {
            guard let url = URL(string: "http://38.242.228.108:5000/api/rooms/\(id)") else { return }
            var req = URLRequest(url: url)
            req.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: req) { _, response, _ in
                if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 {
                    completion()
                }
            }.resume()
        }
    @IBAction func addBtnPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddRoomVC") as? AddRoomViewController {
            vc.onAddSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rooms.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        let r = rooms[indexPath.row]
        cell.lblID.text = "ID: \(r.room_id ?? 0)"
        cell.lblNumber.text = "Phòng: \(r.room_number)"
        cell.lblPrice.text = "Giá: \(r.price_per_night)"
        cell.lblStatus.text = "TT: \(r.status)"
        cell.imgAvatar.image = UIImage(systemName: "tag.circle.fill")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditRoomVC") as? EditRoomViewController {
            vc.room = rooms[indexPath.row]
            vc.onEditSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - 4. MÀN HÌNH THÊM (AddRoomViewController)
class AddRoomViewController: UIViewController {
    @IBOutlet weak var txtNumber: UITextField!; @IBOutlet weak var txtFloor: UITextField!
    @IBOutlet weak var txtPrice: UITextField!; @IBOutlet weak var txtMaxGuests: UITextField!
    @IBOutlet weak var txtBedCount: UITextField!; @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtStatus: UITextField!; @IBOutlet weak var txtTypeName: UITextField!
    
    var onAddSuccess: (() -> Void)?

    @IBAction func saveBtnPressed(_ sender: Any) {
        // Kiểm tra an toàn giá trị số, tránh NaN
        let floor = Int(txtFloor.text ?? "") ?? 0
        let maxGuests = Int(txtMaxGuests.text ?? "") ?? 0
        let bedCount = Int(txtBedCount.text ?? "") ?? 0
        
        let newRoom = Room(room_id: nil, room_number: txtNumber.text ?? "", room_type_id: 1, floor: floor, price_per_night: txtPrice.text ?? "0", max_guests: maxGuests, bed_count: bedCount, description: txtDesc.text ?? "", status: txtStatus.text ?? "available", is_active: true, room_type_name: txtTypeName.text ?? "")
        
        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/rooms")!)
        req.httpMethod = "POST"; req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(newRoom)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            if (response as? HTTPURLResponse)?.statusCode == 201 {
                DispatchQueue.main.async { self.onAddSuccess?(); self.navigationController?.popViewController(animated: true) }
            }
        }.resume()
    }
}

// MARK: - 5. MÀN HÌNH SỬA (EditRoomViewController)
class EditRoomViewController: UIViewController {
    @IBOutlet weak var txtID: UITextField!; @IBOutlet weak var txtNumber: UITextField!; @IBOutlet weak var txtFloor: UITextField!
    @IBOutlet weak var txtPrice: UITextField!; @IBOutlet weak var txtMaxGuests: UITextField!; @IBOutlet weak var txtBedCount: UITextField!
    @IBOutlet weak var txtDesc: UITextField!; @IBOutlet weak var txtStatus: UITextField!; @IBOutlet weak var txtTypeName: UITextField!
    
    var room: Room?
    var onEditSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let r = room {
            txtID.text = "\(r.room_id ?? 0)"; txtNumber.text = r.room_number; txtFloor.text = "\(r.floor)"
            txtPrice.text = r.price_per_night; txtMaxGuests.text = "\(r.max_guests)"; txtBedCount.text = "\(r.bed_count)"
            txtDesc.text = r.description; txtStatus.text = r.status; txtTypeName.text = r.room_type_name
            txtID.isEnabled = false
        }
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let r = room, let id = r.room_id else { return }
        
        // Kiểm tra an toàn giá trị số, tránh NaN
        let floor = Int(txtFloor.text ?? "") ?? r.floor
        let maxGuests = Int(txtMaxGuests.text ?? "") ?? r.max_guests
        let bedCount = Int(txtBedCount.text ?? "") ?? r.bed_count
        
        let updatedRoom = Room(room_id: id, room_number: txtNumber.text ?? "", room_type_id: r.room_type_id, floor: floor, price_per_night: txtPrice.text ?? "0", max_guests: maxGuests, bed_count: bedCount, description: txtDesc.text ?? "", status: txtStatus.text ?? r.status, is_active: r.is_active, room_type_name: txtTypeName.text ?? "")
        
        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/rooms/\(id)")!)
        req.httpMethod = "PUT"; req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(updatedRoom)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                DispatchQueue.main.async { self.onEditSuccess?(); self.navigationController?.popViewController(animated: true) }
            }
        }.resume()
    }
}
