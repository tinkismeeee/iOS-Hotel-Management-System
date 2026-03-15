//
//  ForgotPassword.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import Alamofire
import UIKit

class ForgotPassword : UIViewController {
    
    @IBOutlet weak var emailInput: PaddedTextFieldLogin!
    let emptyAlert = UIAlertController(title: "Error", message: "Email must be filled", preferredStyle: .alert)
    let notFoundAlert = UIAlertController(title: "Error", message: "Email not found", preferredStyle: .alert)
    let emailValid = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        emptyAlert.addAction(okAction)
        notFoundAlert.addAction(okAction)
        // Do any additional setup after loading the view.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Next" {
            return emailValid
        }
        return true
    }
    @IBAction func nextBtn(_ sender: Any) {
        let email = emailInput.text ?? ""
        if (email.isEmpty) {
            present(emptyAlert, animated: true)
            return
        }
        Service.shared.getCustomerByEmail(email: email) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Next", sender: nil)
                }
            case .failure:
                DispatchQueue.main.async {
                    print(result)
                    self.present(self.notFoundAlert, animated: true)
                }
            }
        }
    }
}
