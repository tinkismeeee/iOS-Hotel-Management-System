//
//  Signup.swift
//  hotel_management_system
//
//  Created by mac on 2026/3/11.
//
import UIKit
import Alamofire
import Foundation
class Signup : UIViewController {
    @IBOutlet weak var nameInput: PaddedTextFieldLogin!
    @IBOutlet weak var emailInput: PaddedTextFieldLogin!
    @IBOutlet weak var phoneInput: PaddedTextFieldLogin!
    @IBOutlet weak var passwordInput: PasswordTextField!
    @IBOutlet weak var DOBPicker: UIDatePicker!
    @IBOutlet weak var addressInput: PaddedTextFieldLogin!
    @IBOutlet weak var usernameInput: PaddedTextFieldLogin!
    let alert = UIAlertController(title: "Error", message: "All information must be filled", preferredStyle: .alert)
    let signUpSuccessfullyAlert = UIAlertController(title: "Success", message: "Signup Successfully", preferredStyle: .alert)
    let Alert500 = UIAlertController(title: "Error", message: "Email already exists", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        let backAction = UIAlertAction(title: "Back", style: .default) { action in
            let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! Login
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(okAction)
        signUpSuccessfullyAlert.addAction(backAction)
        signUpSuccessfullyAlert.addAction(okAction)
        Alert500.addAction(okAction)

    }
    @IBAction func createAccountBtn(_ sender: Any) {
        let name = nameInput.text ?? ""
        let email = emailInput.text ?? ""
        let phone = phoneInput.text ?? ""
        let username = usernameInput.text ?? ""
        let password = passwordInput.text ?? ""
        let address = addressInput.text ?? ""
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let DOB = DOBPicker.date
        let real_DOB = formater.string(from: DOB)
        if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || address.isEmpty || username.isEmpty) {
            present(alert, animated: true, completion: nil)
            nameInput.text = ""
            emailInput.text = ""
            phoneInput.text = ""
            passwordInput.text = ""
            addressInput.text = ""
            usernameInput.text = ""
        }
        else {
            let parts = name.split(separator: " ")
            let first_name = parts.first.map { String($0) } ?? ""
            let last_name = parts.dropFirst().joined(separator: " ")
            let body = SignupModel(username: username, email: email, password: password, first_name: first_name, last_name: last_name, phone_number: phone, address: address, date_of_birth:real_DOB)
            print(body)
            Service.shared.signUp(body: body) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        print(String(data: data, encoding: .utf8) ?? "OK")
                        print("OK")
                        DispatchQueue.main.async {
                            self.present(self.signUpSuccessfullyAlert, animated: true)
                            self.nameInput.text = ""
                            self.emailInput.text = ""
                            self.passwordInput.text = ""
                            self.phoneInput.text = ""
                            self.addressInput.text = ""
                            self.usernameInput.text = ""
                        }
                    }
                case .failure(let error):
                    print("Lỗi")
                    print(error)
                    if let statusCode = error.responseCode {
                        if statusCode == 500 {
                            DispatchQueue.main.async {
                                self.present(self.Alert500, animated: true)
                                self.nameInput.text = ""
                                self.emailInput.text = ""
                                self.passwordInput.text = ""
                                self.phoneInput.text = ""
                                self.addressInput.text = ""
                                self.usernameInput.text = ""
                            }
                        }
                    }
                }
            }
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
