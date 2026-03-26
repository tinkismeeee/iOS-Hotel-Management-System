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
    var data: PaymentDetailModel
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://img.vietqr.io/image/vietinbank-113366668888-compact2.jpg?amount=790000&addInfo=dong%20gop%20quy%20vac%20xin&accountName=Quy%20Vac%20Xin%20Covid")
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
