//
//  CreateNewPassword.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import UIKit
import Alamofire

class CreateNewPassword: UIViewController {

    @IBOutlet weak var passwordInput: PasswordTextField!
    @IBOutlet weak var passwordConfirmInput: PasswordTextField!
    let emptyAlert = UIAlertController(title: "Error", message: "All fields must be filled", preferredStyle: .alert)
    let dontMatchAlert = UIAlertController(title: "Error", message: "Passwords don't match", preferredStyle: .alert)
    let updateAlert = UIAlertController(title: "Success", message: "Password updated successfully", preferredStyle: .alert)
    let updateAlertError = UIAlertController(title: "Error", message: "Password updated fail", preferredStyle: .alert)
    let loginInfo = UserDefaults.standard
    var userEmail: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        let okActionUpdate = UIAlertAction(title: "OK", style: .default) {
            (action) in self.navigationController?.popToRootViewController(animated: true)
        }
        emptyAlert.addAction(okAction)
        dontMatchAlert.addAction(okAction)
        updateAlert.addAction(okActionUpdate)
        updateAlertError.addAction(okAction)
        print("Email received:", userEmail ?? "nil")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let password = passwordInput.text ?? ""
        let passwordConfirm = passwordConfirmInput.text ?? ""
        if (password.isEmpty || passwordConfirm.isEmpty) {
            present(emptyAlert, animated: true)
            return
        }
        if (password != passwordConfirm) {
            present(dontMatchAlert, animated: true)
            return
        }
        guard let email = userEmail else { return }
        let body = UpdatePasswordModel(email: email, newPassword: password)
        Service.shared.updatePassword(body: body) { result in
            print(body)
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.passwordInput.text = ""
                    self.passwordConfirmInput.text = ""
                    self.present(self.updateAlert, animated: true)
                }
            case .failure(let error):
                print("Error:", error)
                DispatchQueue.main.async {
                    self.present(self.updateAlertError, animated: true)
                }
            }
        }
    }
}
