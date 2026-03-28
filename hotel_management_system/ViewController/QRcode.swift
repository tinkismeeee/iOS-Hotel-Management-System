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

    @IBAction func paid(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "home") as! Home
        // print(navigationController)
        navigationController?.pushViewController(vc, animated: true)
    }
}
