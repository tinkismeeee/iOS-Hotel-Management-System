import UIKit

// MARK: - 1. MODEL
struct AdminInvoice: Codable {
    var invoice_id: Int?
    var booking_id: Int
    var staff_id: Int
    var issue_date: String?
    var total_room_cost: String
    var total_service_cost: String
    var discount_amount: String? // Nên để String? vì dữ liệu có thể là null
    var final_amount: String
    var vat_amount: String
    var payment_method: String
    var promotion_id: Int?
    var payment_status: String
    var total_amount: String?
    var tax_amount: String? // Đã sửa tên từ tax_mount thành tax_amount
    
    // Sử dụng CodingKeys để map chính xác nếu bạn muốn tên biến trong code khác với JSON
    enum CodingKeys: String, CodingKey {
        case invoice_id, booking_id, staff_id, issue_date, total_room_cost,
             total_service_cost, discount_amount, final_amount, vat_amount,
             payment_method, promotion_id, payment_status, total_amount, tax_amount
    }
}

// MARK: - 2. CUSTOM CELL (InvoiceCell)
class InvoiceCell: UITableViewCell {
    @IBOutlet weak var lblInvoiceID: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblPromotionID: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
}

// MARK: - 3. DANH SÁCH (InvoiceListViewController)
class InvoiceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var invoices: [AdminInvoice] = []
    let apiURL = "http://38.242.228.108:5000/api/invoices"

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
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { print("Lỗi kết nối: \(error)"); return }
            if let data = data {
                // In thử dữ liệu thô ra console xem nó có về không
                let jsonString = String(data: data, encoding: .utf8)
                print("Dữ liệu thô từ API: \(jsonString ?? "Không có dữ liệu")")
                
                if let decoded = try? JSONDecoder().decode([AdminInvoice].self, from: data) {
                    DispatchQueue.main.async {
                        self.invoices = decoded
                        self.tableView.reloadData()
                    }
                } else {
                    print("Lỗi giải mã JSON - Kiểm tra lại Model với API")
                }
            }
        }.resume()
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddInvoiceVC") as? AddInvoiceViewController {
            vc.onSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func editModeBtnPressed(_ sender: UIBarButtonItem) {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        sender.title = isEditing ? "Xong" : "Sửa"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath) as! InvoiceCell
        let inv = invoices[indexPath.row]
        
        cell.lblInvoiceID.text = "Hóa đơn: #\(inv.invoice_id ?? 0)"
        cell.lblBookingID.text = "Mã Đặt: \(inv.booking_id)"
        cell.lblPromotionID.text = "Khuyến mãi: \(inv.promotion_id ?? 0)"
        cell.lblStatus.text = "Trạng thái: \(inv.payment_status.uppercased())"
        cell.imgAvatar.image = UIImage(systemName: "doc.text.below.ecg.fill")
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditInvoiceVC") as? EditInvoiceViewController {
            vc.invoice = invoices[indexPath.row]
            vc.onSuccess = { self.fetchData() }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = invoices[indexPath.row].invoice_id else { return }
            var req = URLRequest(url: URL(string: "\(apiURL)/\(id)")!)
            req.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: req) { _, response, _ in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.invoices.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - 4. MÀN HÌNH THÊM (AddInvoiceViewController)
class AddInvoiceViewController: UIViewController {
    @IBOutlet weak var txtBookingID: UITextField!
    @IBOutlet weak var txtStaffID: UITextField!
    @IBOutlet weak var txtRoomCost: UITextField!
    @IBOutlet weak var txtServiceCost: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtFinal: UITextField!
    @IBOutlet weak var txtVAT: UITextField!
    @IBOutlet weak var txtMethod: UITextField!
    @IBOutlet weak var txtPromotionID: UITextField!
    @IBOutlet weak var txtStatus: UITextField!

    var onSuccess: (() -> Void)?

    @IBAction func saveBtnPressed(_ sender: Any) {
        let newInv = AdminInvoice(
            invoice_id: nil,
            booking_id: Int(txtBookingID.text ?? "") ?? 0,
            staff_id: Int(txtStaffID.text ?? "") ?? 0,
            issue_date: nil,
            total_room_cost: txtRoomCost.text ?? "0",
            total_service_cost: txtServiceCost.text ?? "0",
            discount_amount: txtDiscount.text ?? "0",
            final_amount: txtFinal.text ?? "0",
            vat_amount: txtVAT.text ?? "0",
            payment_method: txtMethod.text ?? "cash",
            promotion_id: Int(txtPromotionID.text ?? ""),
            payment_status: txtStatus.text ?? "unpaid"
        )

        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/invoices")!)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(newInv)

        URLSession.shared.dataTask(with: req) { _, response, _ in
            if (response as? HTTPURLResponse)?.statusCode == 201 {
                DispatchQueue.main.async { self.onSuccess?(); self.navigationController?.popViewController(animated: true) }
            }
        }.resume()
    }
}

// MARK: - 5. MÀN HÌNH SỬA (EditInvoiceViewController)
class EditInvoiceViewController: UIViewController {
    @IBOutlet weak var txtInvoiceID: UITextField!
    @IBOutlet weak var txtBookingID: UITextField!
    @IBOutlet weak var txtStaffID: UITextField!
    @IBOutlet weak var txtRoomCost: UITextField!
    @IBOutlet weak var txtServiceCost: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtFinal: UITextField!
    @IBOutlet weak var txtVAT: UITextField!
    @IBOutlet weak var txtMethod: UITextField!;
    @IBOutlet weak var txtPromotionID: UITextField!
    @IBOutlet weak var txtStatus: UITextField!

    var invoice: AdminInvoice?
    var onSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let i = invoice {
            txtInvoiceID.text = "\(i.invoice_id ?? 0)"
            txtBookingID.text = "\(i.booking_id)"
            txtStaffID.text = "\(i.staff_id)"
            txtRoomCost.text = i.total_room_cost
            txtServiceCost.text = i.total_service_cost
            txtDiscount.text = i.discount_amount
            txtFinal.text = i.final_amount
            txtVAT.text = i.vat_amount
            txtMethod.text = i.payment_method
            txtPromotionID.text = "\(i.promotion_id ?? 0)"
            txtStatus.text = i.payment_status
            txtInvoiceID.isEnabled = false
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let i = invoice, let id = i.invoice_id else { return }
        
        let updated = AdminInvoice(
            invoice_id: id,
            booking_id: Int(txtBookingID.text ?? "") ?? i.booking_id,
            staff_id: Int(txtStaffID.text ?? "") ?? i.staff_id,
            issue_date: i.issue_date,
            total_room_cost: txtRoomCost.text ?? i.total_room_cost,
            total_service_cost: txtServiceCost.text ?? i.total_service_cost,
            discount_amount: txtDiscount.text ?? i.discount_amount,
            final_amount: txtFinal.text ?? i.final_amount,
            vat_amount: txtVAT.text ?? i.vat_amount,
            payment_method: txtMethod.text ?? i.payment_method,
            promotion_id: Int(txtPromotionID.text ?? ""),
            payment_status: txtStatus.text ?? i.payment_status
        )

        var req = URLRequest(url: URL(string: "http://38.242.228.108:5000/api/invoices/\(id)")!)
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
