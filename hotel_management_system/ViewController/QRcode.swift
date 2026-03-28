//
//  QRcode.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 26/3/26.
//

import UIKit
import WebKit

class QRcode: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var data: PaymentDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // check
        if let data = data {
                print(data)
        }
        else {
            print("general data is null")
        }
        let myURL = URL(string:"https://vietqr.co/api/generate/vba/4815205123757/NGUYEN%20HUU%20TINH/\(data?.total ?? 0)/THANH%20TOAN%20\(String(UUID().uuidString.prefix(7)))?isMask=0&logo=1&style=1&bg=\(Int.random(in: 1...80))")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    @IBAction func paid(_ sender: Any) {
        let user_id = UserDefaults.standard.integer(forKey: "userId")
        let check_in = formatDate(data?.checkIn)
        let check_out = formatDate(data?.checkOut)
        let total_guests = data?.room?.max_guests ?? 0
        let room_ids = data?.room?.room_id ?? 0
        let total_price = data?.total ?? 0
        let body = BookingModel(user_id: user_id, check_in: check_in, check_out: check_out, total_guests: total_guests, total_price: total_price, room_id: [room_ids])
        print(body)
        Service.shared.createBooking(body: body) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    print(String(data: data, encoding: .utf8) ?? "")
                } else {
                    print("Create booking success but data is nil")
                }
                DispatchQueue.main.async {
            
                }
            case .failure(let error):
                print("Create booking failed: \(error)")
            }
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "home") as! Home
//        // print(navigationController)
//        navigationController?.pushViewController(vc, animated: true)
        
    }
}
