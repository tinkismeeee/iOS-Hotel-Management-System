//
//  ServiceManagementViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class ServiceManagementViewController: UIViewController {

    
    @IBOutlet weak var serviceTableView: UITableView!
    var serviceList: [ServiceModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Đăng ký cung cấp dữ liệu cho bảng
        serviceTableView.dataSource = self
        serviceTableView.delegate = self
        serviceTableView.rowHeight = 100
        // Gọi API
        fetchServices()
    }
    
    func fetchServices() {
            guard let url = URL(string: "http://38.242.228.108:5000/api/services") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Lỗi kết nối API: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let services = try JSONDecoder().decode([ServiceModel].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.serviceList = services
                        self.serviceTableView.reloadData() // Cập nhật lại giao diện
                    }
                } catch {
                    print("Lỗi giải mã JSON: \(error)")
                }
            }
            task.resume()
        }
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showServiceDetail" {
                if let detailVC = segue.destination as? ServiceDetailViewController {
                    // Lấy ra vị trí hàng đang được bấm
                    if let indexPath = serviceTableView.indexPathForSelectedRow {
                        // Lấy dữ liệu và truyền sang
                        let selectedService = serviceList[indexPath.row]
                        detailVC.serviceData = selectedService
                        
                        // Hiệu ứng nhả highlight sau khi bấm
                        serviceTableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }

}
// MARK: - TableView DataSource & Delegate
extension ServiceManagementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceTableViewCell
            
            let service = serviceList[indexPath.row]
            
            // 1. Gán Tên và Mã
            cell.nameLabel.text = "\(service.name) (\(service.serviceCode))"
            
            // 2. Định dạng Giá tiền
            if let priceDouble = Double(service.price) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                cell.priceLabel.text = "\(formatter.string(from: NSNumber(value: priceDouble)) ?? service.price) VNĐ"
            }
            
            // 3. Xử lý nhãn trạng thái (Mở = Xanh, Đóng = Đỏ)
            if service.availability {
                cell.statusBadgeLabel.text = " Đang mở "
                cell.statusBadgeLabel.backgroundColor = .systemGreen
            } else {
                cell.statusBadgeLabel.text = " Tạm ngưng "
                cell.statusBadgeLabel.backgroundColor = .systemRed
            }
            
            // 4. (Tùy chọn) Đổi icon động cho ngầu
            let nameLower = service.name.lowercased()
            if nameLower.contains("laundry") {
                cell.iconImageView.image = UIImage(systemName: "washer.fill") // Icon máy giặt
            } else if nameLower.contains("breakfast") || nameLower.contains("dinner") {
                cell.iconImageView.image = UIImage(systemName: "fork.knife") // Icon dao nĩa
            } else if nameLower.contains("spa") {
                cell.iconImageView.image = UIImage(systemName: "leaf.fill") // Icon chiếc lá
            } else {
                cell.iconImageView.image = UIImage(systemName: "tray.full.fill") // Icon mặc định
            }
            
            return cell
        }
}
