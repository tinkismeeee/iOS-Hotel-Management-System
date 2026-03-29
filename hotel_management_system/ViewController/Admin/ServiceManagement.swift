import UIKit

// MARK: - 1. MODEL
struct ServiceAdmin: Codable {
    var service_id: Int?
    var service_code: String
    var name: String
    var price: String
    var availability: Bool
    var description: String
}

// MARK: - 2. CUSTOM CELL
class ServiceCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet  weak var imgAvatar: UIImageView!
}

// MARK: - 3. DANH SÁCH (ServiceListViewController)
class ServiceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var services: [ServiceAdmin] = []
    let apiURL = "http://38.242.228.108:5000/api/services"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    func fetchData() {
        guard let url = URL(string: apiURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode([ServiceAdmin].self, from: data) {
                DispatchQueue.main.async {
                    self.services = decoded
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        // Sử dụng Identifier: AddServiceVC
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddServiceVC") as? AddServiceViewController {
            vc.onSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        sender.title = isEditing ? "Xong" : "Sửa"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        let s = services[indexPath.row]
        cell.lblID.text = "ID: \(s.service_id ?? 0)"
        cell.lblCode.text = "Mã: \(s.service_code)"
        cell.lblName.text = "Tên: \(s.name)"
        cell.lblPrice.text = "Giá: \(s.price)"
        cell.imgAvatar.image = UIImage(systemName: "box.truck.fill")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Sử dụng Identifier: EditServiceVC
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditServiceVC") as? EditServiceViewController {
            vc.service = services[indexPath.row]
            vc.onSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = services[indexPath.row].service_id ?? 0
            let deleteURL = "\(apiURL)/\(id)"
            var req = URLRequest(url: URL(string: deleteURL)!)
            req.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: req) { _, response, _ in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.services.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - 4. MÀN HÌNH THÊM (AddServiceViewController)
// Storyboard ID: AddServiceVC
class AddServiceViewController: UIViewController {
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    
    var onSuccess: (() -> Void)?

    @IBAction func saveBtnPressed(_ sender: Any) {
        let newService = ServiceAdmin(service_id: nil, service_code: txtCode.text ?? "", name: txtName.text ?? "", price: txtPrice.text ?? "0", availability: true, description: txtDesc.text ?? "")
        
        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/services")!)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(newService)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            if (response as? HTTPURLResponse)?.statusCode == 201 {
                DispatchQueue.main.async { self.onSuccess?(); self.navigationController?.popViewController(animated: true) }
            }
        }.resume()
    }
}

// MARK: - 5. MÀN HÌNH SỬA (EditServiceViewController)
// Storyboard ID: EditServiceVC
class EditServiceViewController: UIViewController {
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    
    var service: ServiceAdmin?
    var onSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let s = service {
            txtCode.text = s.service_code
            txtName.text = s.name
            txtPrice.text = s.price
            txtDesc.text = s.description
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let s = service, let id = s.service_id else { return }
        let updated = ServiceAdmin(service_id: id, service_code: txtCode.text ?? s.service_code, name: txtName.text ?? s.name, price: txtPrice.text ?? s.price, availability: s.availability, description: txtDesc.text ?? s.description)
        
        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/services/\(id)")!)
        req.httpMethod = "PUT"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(updated)
        
        URLSession.shared.dataTask(with: req) { _, response, _ in
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                DispatchQueue.main.async { self.onSuccess?(); self.navigationController?.popViewController(animated: true) }
            }
        }.resume()
    }
}
