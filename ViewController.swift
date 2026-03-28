import UIKit

// MARK: - 1. MODEL CHO DANH SÁCH MENU
struct DashboardItem {
    let title: String
    let description: String
    let iconName: String
    let segueIdentifier: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // 3 CỔNG KẾT NỐI CHO THỐNG KÊ (Giữ nguyên)
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblGuests: UILabel!
    
    // THÊM CỔNG KẾT NỐI CHO THANH TÌM KIẾM
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - 2. DỮ LIỆU MENU GỐC
    private let allItems: [DashboardItem] = [
        DashboardItem(title: "Quản lý Nhân viên", description: "Xem, thêm, sửa, xóa nhân viên", iconName: "person.3.fill", segueIdentifier: "showStaff"),
        DashboardItem(title: "Quản lý Khách hàng", description: "Hồ sơ lưu trú của khách", iconName: "person.crop.rectangle.fill", segueIdentifier: "showCustomer"),
        DashboardItem(title: "Quản lý Loại phòng", description: "Cài đặt các hạng phòng", iconName: "door.left.hand.closed", segueIdentifier: "showRoomTypes"),
        DashboardItem(title: "Quản lý Phòng", description: "Theo dõi tình trạng phòng trống", iconName: "bed.double.fill", segueIdentifier: "showRooms"),
        DashboardItem(title: "Quản lý Dịch vụ", description: "Dịch vụ ăn uống, dọn dẹp...", iconName: "sparkles", segueIdentifier: "showServices"),
        DashboardItem(title: "Mã Giảm giá", description: "Tạo và quản lý voucher", iconName: "ticket.fill", segueIdentifier: "showPromotions"),
        DashboardItem(title: "Quản lý Doanh thu", description: "Hóa đơn và thống kê tài chính", iconName: "dollarsign.circle.fill", segueIdentifier: "showInvoices"),
        DashboardItem(title: "Đăng xuất", description: "Thoát khỏi phiên làm việc", iconName: "arrow.right.square.fill", segueIdentifier: "logout")
    ]
    
    // MẢNG LƯU KẾT QUẢ TÌM KIẾM (Bảng sẽ hiển thị mảng này)
    var filteredItems: [DashboardItem] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchDashboardData() // Gọi API thống kê
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ban đầu chưa gõ gì thì mảng tìm kiếm = toàn bộ menu
        filteredItems = allItems
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        // LẮNG NGHE SỰ KIỆN KHI NGƯỜI DÙNG GÕ PHÍM
        searchTextField?.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - HÀM XỬ LÝ TÌM KIẾM THEO THỜI GIAN THỰC
    @objc func searchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text, !searchText.isEmpty else {
            // Nếu xóa hết chữ, hiển thị lại toàn bộ Menu
            filteredItems = allItems
            tableView.reloadData()
            return
        }
        
        // Lọc danh sách (Tìm theo tiêu đề hoặc mô tả, không phân biệt hoa thường)
        filteredItems = allItems.filter { item in
            item.title.lowercased().contains(searchText.lowercased()) ||
            item.description.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    // MARK: - HÀM LẤY DATA TỪ API (Đã giữ nguyên phần thống kê của bạn)
    func fetchDashboardData() {
        URLSession.shared.dataTask(with: URL(string: "http://38.242.228.108:5000/api/customers")!) { data, _, _ in
            if let data = data, let customers = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                DispatchQueue.main.async { self.lblGuests?.text = "\(customers.count)" }
            }
        }.resume()

        URLSession.shared.dataTask(with: URL(string: "http://38.242.228.108:5000/api/rooms")!) { data, _, _ in
            if let data = data, let rooms = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                let totalRooms = rooms.count
                let availableRooms = rooms.filter { ($0["status"] as? String) == "available" }.count
                DispatchQueue.main.async { self.lblRooms?.text = "\(availableRooms)/\(totalRooms)" }
            }
        }.resume()

        URLSession.shared.dataTask(with: URL(string: "http://38.242.228.108:5000/api/invoices")!) { data, _, _ in
            if let data = data, let invoices = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                var totalRevenue: Double = 0
                for invoice in invoices {
                    if let finalAmountStr = invoice["final_amount"] as? String, let amount = Double(finalAmountStr) {
                        totalRevenue += amount
                    }
                }
                DispatchQueue.main.async {
                    if totalRevenue >= 1000 {
                        self.lblRevenue?.text = String(format: "$%.1fK", totalRevenue / 1000)
                    } else {
                        self.lblRevenue?.text = String(format: "$%.0f", totalRevenue)
                    }
                }
            }
        }.resume()
    }

    // MARK: - CẤU HÌNH TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TÍNH NĂNG MÀN HÌNH TRỐNG: NẾU TÌM KHÔNG RA SẼ BÁO LỖI
        if filteredItems.isEmpty {
            tableView.setEmptyMessage("Không tìm thấy chức năng nào phù hợp.")
        } else {
            tableView.restore()
        }
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // LẤY DỮ LIỆU TỪ MẢNG ĐÃ ĐƯỢC LỌC
        let item = filteredItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        if let imgIcon = cell.viewWithTag(101) as? UIImageView {
            imgIcon.image = UIImage(systemName: item.iconName)
            imgIcon.tintColor = item.segueIdentifier == "logout" ? .systemRed : UIColor(red: 15/255, green: 34/255, blue: 70/255, alpha: 1.0)
        }
        if let lblTitle = cell.viewWithTag(102) as? UILabel {
            lblTitle.text = item.title
            lblTitle.textColor = item.segueIdentifier == "logout" ? .systemRed : .black
        }
        if let lblDesc = cell.viewWithTag(103) as? UILabel {
            lblDesc.text = item.description
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = filteredItems[indexPath.row]

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()

        if item.segueIdentifier == "logout" {
            showLogoutAlert()
            return
        }

        performSegue(withIdentifier: item.segueIdentifier, sender: self)
    }

    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc muốn đăng xuất không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive) { _ in })
        present(alert, animated: true)
    }
}

// MARK: - EXTENSION CHO MÀN HÌNH TRỐNG
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
