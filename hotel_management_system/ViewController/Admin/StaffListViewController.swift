import UIKit

// MARK: - 1. MODEL
struct Staff: Codable {
    var user_id: Int?
    var username: String
    var email: String
    var first_name: String
    var last_name: String
    var phone_number: String
    var password: String? // Dùng cho chức năng Add
    var is_active: Bool?
}

// MARK: - 2. SERVICE LAYER
class StaffService {
    static let shared = StaffService()
    private let baseURL = "http://38.242.228.108:5000/api/staff"
    
    func fetchStaffs(completion: @escaping ([Staff]?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let decoded = try? JSONDecoder().decode([Staff].self, from: data)
            DispatchQueue.main.async { completion(decoded) }
        }.resume()
    }
    
    func addStaff(staff: Staff, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(staff)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 201
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
    
    func updateStaff(id: Int, staff: Staff, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(staff)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
    
    func deleteStaff(id: Int, completion: @escaping (Bool) -> Void) {
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
class StaffCell: UITableViewCell {
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
}

// MARK: - 4. DANH SÁCH (StaffListViewController)
class StaffListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var staffs: [Staff] = []
    
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
        StaffService.shared.fetchStaffs { [weak self] data in
            if let data = data {
                self?.staffs = data
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddStaffVC") as? AddStaffViewController {
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell", for: indexPath) as! StaffCell
        let s = staffs[indexPath.row]
        
        cell.lblUserID.text = "ID: \(s.user_id ?? 0)"
        cell.lblUsername.text = "User: \(s.username)"
        cell.lblEmail.text = "Email: \(s.email)"
        cell.lblPhone.text = "Phone: \(s.phone_number)"
        cell.imgAvatar.image = UIImage(systemName: "doc.text.below.ecg.fill")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditStaffVC") as? EditStaffViewController {
            vc.staff = staffs[indexPath.row]
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = staffs[indexPath.row].user_id else { return }
            
            StaffService.shared.deleteStaff(id: id) { success in
                if success {
                    self.staffs.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

// MARK: - 5. MÀN HÌNH THÊM (AddStaffViewController)
class AddStaffViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField! // Thêm pass khi tạo mới
    
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
        let newStaff = Staff(
            user_id: nil,
            username: txtUsername.text ?? "",
            email: txtEmail.text ?? "",
            first_name: txtFirstName.text ?? "",
            last_name: txtLastName.text ?? "",
            phone_number: txtPhone.text ?? "",
            password: txtPassword.text ?? "123456",
            is_active: true
        )
        
        StaffService.shared.addStaff(staff: newStaff) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - 6. MÀN HÌNH SỬA (EditStaffViewController)
class EditStaffViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var staff: Staff?
    var onSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let s = staff {
            txtUsername.text = s.username
            txtEmail.text = s.email
            txtFirstName.text = s.first_name
            txtLastName.text = s.last_name
            txtPhone.text = s.phone_number
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    @IBAction func updatePressed(_ sender: Any) {
        guard let id = staff?.user_id else { return }
        
        let updated = Staff(
            user_id: id,
            username: txtUsername.text ?? "",
            email: txtEmail.text ?? "",
            first_name: txtFirstName.text ?? "",
            last_name: txtLastName.text ?? "",
            phone_number: txtPhone.text ?? "",
            is_active: staff?.is_active
        )
        
        StaffService.shared.updateStaff(id: id, staff: updated) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
