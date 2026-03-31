import UIKit

// MARK: - 1. MODEL
struct RoomType: Codable {
    var room_type_id: Int?
    var name: String
    var description: String
}

// MARK: - 2. SERVICE LAYER
class RoomTypeService {
    static let shared = RoomTypeService()
    private let baseURL = "http://38.242.228.108:5000/api/room-types"
    
    func fetchRoomTypes(completion: @escaping ([RoomType]?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let decoded = try? JSONDecoder().decode([RoomType].self, from: data)
            DispatchQueue.main.async { completion(decoded) }
        }.resume()
    }
    
    func addRoomType(roomType: RoomType, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(roomType)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 201
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
    
    func updateRoomType(id: Int, roomType: RoomType, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(roomType)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
    
    func deleteRoomType(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
}

// MARK: - 3. CUSTOM CELL
class RoomTypeCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
}

// MARK: - 4. DANH SÁCH (RoomTypeListViewController)
class RoomTypeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var roomTypes: [RoomType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func loadData() {
        RoomTypeService.shared.fetchRoomTypes { [weak self] data in
            if let data = data {
                self?.roomTypes = data
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func editModeBtnPressed(_ sender: UIBarButtonItem) {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        sender.title = isEditing ? "Xong" : "Sửa"
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddRoomTypeVC") as? AddRoomTypeViewController {
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath) as! RoomTypeCell
        let rt = roomTypes[indexPath.row]
        
        cell.lblID.text = "ID: \(rt.room_type_id ?? 0)"
        cell.lblName.text = rt.name
        cell.lblDescription.text = rt.description
        cell.imgIcon.image = UIImage(systemName: "door.left.hand.open")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditRoomTypeVC") as? EditRoomTypeViewController {
            vc.roomType = roomTypes[indexPath.row]
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // NÚT XOÁ ĐÃ ĐƯỢC THÊM TẠI ĐÂY
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = roomTypes[indexPath.row].room_type_id else { return }
            
            RoomTypeService.shared.deleteRoomType(id: id) { success in
                if success {
                    self.roomTypes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

// MARK: - 5. MÀN HÌNH THÊM (AddRoomTypeViewController)
class AddRoomTypeViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    var onSuccess: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func savePressed(_ sender: Any) {
        let newRT = RoomType(
            room_type_id: nil,
            name: txtName.text ?? "",
            description: txtDescription.text ?? ""
        )
        
        RoomTypeService.shared.addRoomType(roomType: newRT) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - 6. MÀN HÌNH SỬA (EditRoomTypeViewController)
class EditRoomTypeViewController: UIViewController {
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    var roomType: RoomType?
    var onSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rt = roomType {
            txtID.text = "\(rt.room_type_id ?? 0)"
            txtName.text = rt.name
            txtDescription.text = rt.description
            txtID.isEnabled = false
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func updatePressed(_ sender: Any) {
        guard let id = roomType?.room_type_id else { return }
        
        let updated = RoomType(
            room_type_id: id,
            name: txtName.text ?? "",
            description: txtDescription.text ?? ""
        )
        
        RoomTypeService.shared.updateRoomType(id: id, roomType: updated) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
