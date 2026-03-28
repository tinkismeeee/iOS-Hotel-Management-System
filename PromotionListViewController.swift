import UIKit

// MARK: - 1. MODEL
struct Promotion: Codable {
    var promotion_id: Int?
    var promotion_code: String
    var name: String
    var discount_value: String
    var description: String
    var scope: String
}

// MARK: - 2. CUSTOM CELL
// Chỉ hiển thị 4 thông tin: ID, Code, Name, Discount
class PromotionCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
}

// MARK: - 3. MÀN HÌNH 1: DANH SÁCH
class PromotionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var promotions: [Promotion] = []
    let apiURL = "http://38.242.228.108:5000/api/promotions"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: apiURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode([Promotion].self, from: data) {
                DispatchQueue.main.async {
                    self.promotions = decoded
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        // Lưu ý: Tôi đổi 'UIButton' thành 'UIBarButtonItem' để khớp với cái nút trên thanh Bar của bạn
        let isNowEditing = !tableView.isEditing
        tableView.setEditing(isNowEditing, animated: true)
        
        // Nếu là nút chữ, nó sẽ đổi tên. Nếu là nút Icon, nó sẽ giữ nguyên icon.
        sender.title = isNowEditing ? "Xong" : "Sửa"
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddPromotionViewController {
            addVC.onAddSuccess = { self.fetchData() }
            navigationController?.pushViewController(addVC, animated: true)
        }
    }

    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath) as! PromotionCell
        let item = promotions[indexPath.row]

        // Chỉ hiển thị 4 thông tin chính trên Cell
        cell.lblID.text = "ID: \(item.promotion_id ?? 0)"
        cell.lblCode.text = "Code: \(item.promotion_code)"
        cell.lblName.text = item.name
        cell.lblDiscount.text = "Giảm: \(item.discount_value)%"
        
        cell.imgAvatar.image = UIImage(systemName: "tag.circle.fill")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editVC = storyboard?.instantiateViewController(withIdentifier: "EditVC") as? EditPromotionViewController {
            editVC.promotion = promotions[indexPath.row]
            editVC.onSaveSuccess = { self.fetchData() }
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    // Xóa sản phẩm
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = promotions[indexPath.row]
            guard let id = item.promotion_id, let url = URL(string: "\(apiURL)/\(id)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { _, resp, _ in
                if (resp as? HTTPURLResponse)?.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.promotions.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - 4. MÀN HÌNH 2: SỬA (Đầy đủ 6 trường)
class EditPromotionViewController: UIViewController {
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtScope: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    
    var promotion: Promotion?
    var onSaveSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let p = promotion {
            txtID.text = "\(p.promotion_id ?? 0)"
            txtCode.text = p.promotion_code
            txtName.text = p.name
            txtDiscount.text = p.discount_value
            txtScope.text = p.scope
            txtDesc.text = p.description
            txtID.isEnabled = false // Không cho sửa ID
        }
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        guard var p = promotion else { return }
        // Cập nhật tất cả các trường từ giao diện
        p.promotion_code = txtCode.text ?? ""
        p.name = txtName.text ?? ""
        p.discount_value = txtDiscount.text ?? ""
        p.scope = txtScope.text ?? ""
        p.description = txtDesc.text ?? ""

        guard let url = URL(string: "http://38.242.228.108:5000/api/promotions/\(p.promotion_id!)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(p)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.onSaveSuccess?()
                self.navigationController?.popViewController(animated: true)
            }
        }.resume()
    }
}

// MARK: - 5. MÀN HÌNH 3: THÊM (Đầy đủ 6 trường)
class AddPromotionViewController: UIViewController {
    @IBOutlet weak var txtID: UITextField! // Thường để trống hoặc ẩn vì API tự sinh
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtScope: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    
    var onAddSuccess: (() -> Void)?

    @IBAction func addNewBtnPressed(_ sender: Any) {
        let newP = Promotion(
            promotion_id: nil,
            promotion_code: txtCode.text ?? "",
            name: txtName.text ?? "",
            discount_value: txtDiscount.text ?? "",
            description: txtDesc.text ?? "",
            scope: txtScope.text ?? ""
        )

        guard let url = URL(string: "http://38.242.228.108:5000/api/promotions") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newP)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.onAddSuccess?()
                self.navigationController?.popViewController(animated: true)
            }
        }.resume()
    }
}
