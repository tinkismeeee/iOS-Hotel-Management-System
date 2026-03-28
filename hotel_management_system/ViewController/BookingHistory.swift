//
//  BookingHistory.swift
//  hotel_management_system
//
//  Created by mac on 28/3/26.
//

import UIKit
import Alamofire

class BookingHistory: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var allBookingHistory: [BookingHistoryModel] = []
    var userBookingHistory: [BookingHistoryModel] = []
    let customerEmail = UserDefaults.standard.string(forKey: "email") ?? ""
    var user_id: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchCustomerByEmail(customerEmail)
    }
    
    func fetchCustomerByEmail(_ email: String) {
        Service.shared.getCustomerByEmail(email: email) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let userId = json["user_id"] as? Int {
                                UserDefaults.standard.set(userId, forKey: "user_id")
                                self?.user_id = userId
//                                // MARK: Temp
//                                self?.user_id = 1
                                self?.fetchAllBooking()
                            } else {
                                print("user_id not found")
                            }
                        }
                    } catch {
                        print("Parse error:", error)
                        print(String(data: data, encoding: .utf8) ?? "")
                    }
                }
            case .failure(let error):
                print("API error:", error)
            }
        }
    }
    
    func fetchAllBooking() {
        Service.shared.getAllBooking { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let bookings = try JSONDecoder().decode([BookingHistoryModel].self, from: data)
                        self?.allBookingHistory = bookings
                        
                        if let currentUserId = self?.user_id {
                            self?.userBookingHistory = bookings.filter { $0.user_id == currentUserId }
                        }
                        DispatchQueue.main.async {
                            print("Fetch all bookings ok")
                            // print(self?.userBookingHistory ?? [])
                            self?.tableView.reloadData()
                        }
                    } catch {
                        print("Decode error: \(error)")
                        print(String(data: data, encoding: .utf8) ?? "Cannot read raw JSON")
                    }
                } else {
                    print("Data is nil")
                }
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }
    func formatCurrency(_ value: Double?) -> String {
        guard let value = value else { return "0 ₫" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0 ₫"
    }
    
    func formatDate(_ isoString: String?) -> String {
        guard let isoString = isoString else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: isoString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        }
        return isoString
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBookingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell", for: indexPath) as! BookingHistoryCell
        let booking = userBookingHistory[indexPath.row]
        cell.roomPrice.text = {
            if let priceString = booking.total_price,
               let price = Double(priceString) {
                return "Price: \(formatCurrency(price))"
            }
            return "N/A"
        }()
        cell.checkinAndCheckoutTime.text =
            "\(formatDate(booking.check_in)) - \(formatDate(booking.check_out))"
        cell.bookingId.text = "Booking ID: \(booking.booking_id ?? 0)"
        cell.roomImage.image = UIImage(named: "avt")
        return cell
    }
}
