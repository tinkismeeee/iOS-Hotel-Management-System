//
//  InvoiceDetailViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 15/03/2026.
//

import UIKit

class InvoiceDetailViewController: UIViewController {

    @IBOutlet weak var invoiceIdLabel: UILabel!
    @IBOutlet weak var dateStatusLabel: UILabel!
    @IBOutlet weak var roomCostLabel: UILabel!
    @IBOutlet weak var serviceCostLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var finalAmountLabel: UILabel!
    
    var invoiceData: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInvoiceUI()
    }
    func setupInvoiceUI() {
        guard let invoice = invoiceData else { return }
            
        // Cắt chuỗi ngày cho ngắn gọn (Lấy 10 ký tự đầu)
        let shortDate = String(invoice.issueDate.prefix(10))
            
        invoiceIdLabel.text = "HÓA ĐƠN SỐ: #\(invoice.invoiceId)"
        dateStatusLabel.text = "Ngày: \(shortDate) | Trạng thái: \(invoice.paymentStatus.uppercased())"
            
        // --- CÔNG CỤ ĐỊNH DẠNG TIỀN TỆ ---
        // Hàm nhỏ này giúp chuyển "500000.00" thành "500,000 VNĐ"
        func formatCurrency(_ amountString: String) -> String {
            if let amount = Double(amountString) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                return (formatter.string(from: NSNumber(value: amount)) ?? amountString) + " VNĐ"
            }
            return amountString + " VNĐ"
        }
            
        // Đổ dữ liệu vào các Label tiền bạc
        roomCostLabel.text = "Tiền phòng: " + formatCurrency(invoice.totalRoomCost)
        serviceCostLabel.text = "Tiền dịch vụ: " + formatCurrency(invoice.totalServiceCost)
        vatLabel.text = "Thuế VAT (10%): " + formatCurrency(invoice.vatAmount)
            
        // Nhấn mạnh dòng Giảm giá và Tổng tiền
        discountLabel.text = "Giảm giá: - " + formatCurrency(invoice.discountAmount)
        discountLabel.textColor = .systemRed // Cho chữ màu đỏ để biết là được trừ tiền
            
        finalAmountLabel.text = "TỔNG THANH TOÁN: " + formatCurrency(invoice.finalAmount)
        finalAmountLabel.textColor = .systemGreen
    }


}
