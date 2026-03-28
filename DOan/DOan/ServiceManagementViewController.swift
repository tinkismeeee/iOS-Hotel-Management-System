//
//  ServiceManagementViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class ServiceManagementViewController: UIViewController {

    
    @IBOutlet weak var serviceTableView: UITableView!
    var serviceList: [Service] = []
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Đăng ký cung cấp dữ liệu cho bảng
            serviceTableView.dataSource = self
            serviceTableView.delegate = self
            
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
                    let services = try JSONDecoder().decode([Service].self, from: data)
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        let serviceData = serviceList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        // Dòng chữ chính: Tên dịch vụ + Mã dịch vụ
        content.text = "\(serviceData.name) (\(serviceData.serviceCode))"
        
        // Xử lý định dạng giá tiền (từ "50000.00" -> "50,000")
        let priceString: String
        if let priceDouble = Double(serviceData.price) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            priceString = formatter.string(from: NSNumber(value: priceDouble)) ?? serviceData.price
        } else {
            priceString = serviceData.price
        }
        
        // Dòng chữ phụ: Trạng thái (hiện chữ Đang mở/Tạm ngưng) và Giá
        let statusText = serviceData.availability ? "Đang mở" : "Tạm ngưng"
        content.secondaryText = "\(statusText) | Giá: \(priceString) VNĐ\n\(serviceData.description)"
        
        cell.contentConfiguration = content
        return cell
    }
}
