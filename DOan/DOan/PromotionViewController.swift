//
//  PromotionViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 28/03/2026.
//

import UIKit

class PromotionViewController: UIViewController {

    
    @IBOutlet weak var promotionTableView: UITableView!
    
    var promotionList: [Promotion] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        promotionTableView.dataSource = self
        promotionTableView.delegate = self
        
        fetchPromotions()
    }
    
    func fetchPromotions() {
        // Chú ý viết hoa chữ P trong đường dẫn nếu API yêu cầu
        guard let url = URL(string: "http://38.242.228.108:5000/api/Promotions") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Lỗi kết nối API Mã giảm giá: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            do {
                let promos = try JSONDecoder().decode([Promotion].self, from: data)
                
                DispatchQueue.main.async {
                    self.promotionList = promos
                    self.promotionTableView.reloadData()
                }
            } catch {
                print("Lỗi giải mã JSON: \(error)")
            }
        }
        task.resume()
    }
}

// MARK: - TableView DataSource & Delegate
extension PromotionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionCell", for: indexPath)
        let promo = promotionList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        // 1. Dòng chữ chính: Tên chương trình + Mã Code (Ví dụ: New Year Discount [PROMO10])
        content.text = "\(promo.name) [\(promo.promotionCode)]"
        
        // 2. Xử lý cắt chuỗi ngày tháng (Từ "2025-01-01T00..." -> "2025-01-01")
        let start = String(promo.startDate.prefix(10))
        let end = String(promo.endDate.prefix(10))
        
        // 3. Dòng chữ phụ: Mức giảm, phạm vi áp dụng và thời hạn
        let status = promo.isActive ? "Đang áp dụng" : "Đã hết hạn"
        
        // Cấu hình chữ hiển thị nhiều dòng
        content.secondaryText = """
        Mức giảm: \(promo.discountValue)% | Áp dụng cho: \(promo.scope.uppercased())
        Thời hạn: \(start) đến \(end)
        Trạng thái: \(status)
        """
        
        // Nếu còn hạn thì hiển thị màu xanh lá, hết hạn màu đỏ/xám cho dễ nhìn
        content.secondaryTextProperties.color = promo.isActive ? .systemGreen : .systemGray
        
        cell.contentConfiguration = content
        return cell
    }
}
