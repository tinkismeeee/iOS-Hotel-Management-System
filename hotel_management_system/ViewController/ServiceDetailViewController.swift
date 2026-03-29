//
//  ServiceDetailViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class ServiceDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var serviceData: ServiceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let service = serviceData {
            nameLabel.text = service.name
            codeLabel.text = "Mã dịch vụ: \(service.serviceCode)"
            descLabel.text = "Mô tả: \(service.description)"
            statusLabel.text = "Trạng thái: \(service.availability ? "Đang mở" : "Tạm ngưng")"
                    
                    // Xử lý giá tiền
            if let priceDouble = Double(service.price) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedPrice = formatter.string(from: NSNumber(value: priceDouble)) ?? service.price
                        priceLabel.text = "Giá: \(formattedPrice) VNĐ"
                    }
            else { priceLabel.text = "Giá: \(service.price) VNĐ"
                }
        }
    }
    


}
