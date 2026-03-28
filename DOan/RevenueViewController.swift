//
//  RevenueViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class RevenueViewController: UIViewController {

    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var invoiceTableView: UITableView!
    var invoiceList: [Invoice] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        invoiceTableView.dataSource = self
        invoiceTableView.delegate = self
            
        fetchInvoices()
    }
    func fetchInvoices() {
        guard let url = URL(string: "http://38.242.228.108:5000/api/invoices") else { return }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Lỗi API Doanh thu: \(error.localizedDescription)")
                return
                }
            guard let data = data else { return }
                
            do {
                let invoices = try JSONDecoder().decode([Invoice].self, from: data)
                    
                DispatchQueue.main.async {
                    self.invoiceList = invoices
                    self.calculateTotalRevenue() // Tính tổng tiền
                    self.invoiceTableView.reloadData() // Vẽ lại bảng
                    }
            } catch {
                print("Lỗi giải mã: \(error)")
            }
        }
        task.resume()
    }
        
        // 2. Hàm tính toán và hiển thị Tổng Doanh Thu
    func calculateTotalRevenue() {
        var total: Double = 0
            
        // Duyệt qua từng hóa đơn và cộng dồn số tiền
        for invoice in invoiceList {
            if let amount = Double(invoice.finalAmount) {
                total += amount
            }
        }
            
        // Định dạng số cho đẹp (VD: 52000000 -> 52,000,000)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "0"
            
        totalRevenueLabel.text = "\(formattedTotal) VNĐ"
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Kiểm tra đúng tên đường nối
        if segue.identifier == "showInvoiceDetail" {
        // Xác định màn hình đích
            if let detailVC = segue.destination as? InvoiceDetailViewController {
                // Lấy ra vị trí dòng (cell) đang được bấm
                if let indexPath = invoiceTableView.indexPathForSelectedRow {
                    // Truyền cục dữ liệu Invoice tương ứng sang
                    let selectedInvoice = invoiceList[indexPath.row]
                    detailVC.invoiceData = selectedInvoice
                    
                    // Tắt hiệu ứng bôi xám sau khi bấm xong
                    invoiceTableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }

}
extension RevenueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath)
        let invoice = invoiceList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        // Rút gọn chuỗi ngày (Từ "2026-03-12T00:00:00.000Z" lấy 10 ký tự đầu thành "2026-03-12")
        let shortDate = String(invoice.issueDate.prefix(10))
        
        content.text = "Hóa đơn #\(invoice.invoiceId) - Ngày: \(shortDate)"
        
        // Xử lý hiển thị giá
        if let priceDouble = Double(invoice.finalAmount) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedPrice = formatter.string(from: NSNumber(value: priceDouble)) ?? invoice.finalAmount
            
            content.secondaryText = "+ \(formattedPrice) VNĐ | \(invoice.paymentStatus.uppercased())"
            content.secondaryTextProperties.color = .systemGreen // Cho chữ màu xanh lá cho cảm giác "có tiền"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}
