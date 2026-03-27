import UIKit

// MARK: - 1. MODEL
struct Customer: Codable {
    var user_id: Int?
    var username: String
    var email: String
    var password_hash: String?
    var password: String? // Dùng cho chức năng Add/Edit
    var first_name: String
    var last_name: String
    var phone_number: String
    var address: String
    var date_of_birth: String?
    var is_active: Bool?
}

// MARK: - 2. SERVICE LAYER
class CustomerService {
    static let shared = CustomerService()
    private let baseURL = "http://38.242.228.108:5000/api/customers"
    
    func fetchCustomers(completion: @escaping ([Customer]?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let decoded = try? JSONDecoder().decode([Customer].self, from: data)
            DispatchQueue.main.async { completion(decoded) }
        }.resume()
    }
    
    func addCustomer(customer: Customer, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(customer)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 201
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
    
    func updateCustomer(id: Int, customer: Customer, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(customer)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            DispatchQueue.main.async { completion(success) }
        }.resume()
    }
}

// MARK: - 3. CUSTOM CELL
class CustomerCell: UITableViewCell {
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
}

// MARK: - 4. DANH SÁCH (CustomerListViewController)
class CustomerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var customers: [Customer] = []
    let apiURL = "http://38.242.228.108:5000/api/customers"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
    }
    
    func loadData() {
        CustomerService.shared.fetchCustomers { [weak self] data in
            if let data = data {
                self?.customers = data
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddCustomerVC") as? AddCustomerViewController {
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
        let c = customers[indexPath.row]
        cell.lblUserID.text = "ID: \(c.user_id ?? 0)"
        cell.lblUsername.text = c.username
        cell.lblEmail.text = c.email
        cell.lblPhone.text = c.phone_number
        cell.imgAvatar.image = UIImage(systemName: "doc.text.below.ecg.fill")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditCustomerVC") as? EditCustomerViewController {
            vc.customer = customers[indexPath.row]
            vc.onSuccess = { self.loadData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // XOÁ THEO API GIỐNG MẪU INVOICE
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = customers[indexPath.row].user_id else { return }
            
            var req = URLRequest(url: URL(string: "\(apiURL)/\(id)")!)
            req.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: req) { _, response, _ in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.customers.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - 5. MÀN HÌNH THÊM (AddCustomerViewController)
class AddCustomerViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    var onSuccess: (() -> Void)?
    
    @IBAction func savePressed(_ sender: Any) {
        let newCust = Customer(
            user_id: nil,
            username: txtUsername.text ?? "",
            email: txtEmail.text ?? "",
            password: txtPassword.text ?? "",
            first_name: txtFirstName.text ?? "",
            last_name: txtLastName.text ?? "",
            phone_number: txtPhone.text ?? "",
            address: txtAddress.text ?? ""
        )
        
        CustomerService.shared.addCustomer(customer: newCust) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - 6. MÀN HÌNH SỬA (EditCustomerViewController)
class EditCustomerViewController: UIViewController {
    @IBOutlet weak var txtUserID: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    var customer: Customer?
    var onSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let c = customer {
            txtUserID.text = "\(c.user_id ?? 0)"
            txtUsername.text = c.username
            txtEmail.text = c.email
            txtFirstName.text = c.first_name
            txtLastName.text = c.last_name
            txtPhone.text = c.phone_number
            txtAddress.text = c.address
            txtUserID.isEnabled = false
        }
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        guard let id = customer?.user_id else { return }
        
        let updated = Customer(
            user_id: id,
            username: txtUsername.text ?? "",
            email: txtEmail.text ?? "",
            first_name: txtFirstName.text ?? "",
            last_name: txtLastName.text ?? "",
            phone_number: txtPhone.text ?? "",
            address: txtAddress.text ?? ""
        )
        
        CustomerService.shared.updateCustomer(id: id, customer: updated) { [weak self] success in
            if success {
                self?.onSuccess?()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
