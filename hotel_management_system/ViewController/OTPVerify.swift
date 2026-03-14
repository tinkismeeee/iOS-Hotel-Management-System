//
//  OTPVerify.swift
//  hotel_management_system
//
//  Created by mac on 14/3/26.
//
import Alamofire
import UIKit

class OTPVerify: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var slot1: CircleTextField!
    @IBOutlet weak var slot3: CircleTextField!
    @IBOutlet weak var slot2: CircleTextField!
    @IBOutlet weak var slot4: CircleTextField!
    @IBOutlet weak var emailHolder: UILabel!
    let alert = UIAlertController(title: "Error", message: "Some required fields are missing", preferredStyle: .alert)
    let sentAlertOK = UIAlertController(title: "Success", message: "OTP code sent successfully", preferredStyle: .alert)
    let sentAlertFail = UIAlertController(title: "Fail", message: "OTP code sent failed", preferredStyle: .alert)
    let verifyAlertFail = UIAlertController(title: "Fail", message: "OTP code verify failed", preferredStyle: .alert)
    var userEmail: String = ""
    var verifySuccess = false
    let loginInfo = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        let resend = UIAlertAction(title: "Resend", style: .default) {
            (action) in
            self.sendOTP(self.userEmail)
        }
        alert.addAction(okAction)
        sentAlertFail.addAction(resend)
        sentAlertOK.addAction(okAction)
        verifyAlertFail.addAction(okAction)
        guard let email = loginInfo.string(forKey: "email") else {
            return
        }
        userEmail = email
        emailHolder.text = email
        sendOTP(userEmail)
        slot1.delegate = self
        slot2.delegate = self
        slot3.delegate = self
        slot4.delegate = self
        slot1.becomeFirstResponder()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "continue" {
            return verifySuccess
        }
        return true
    }
    @IBAction func submitBtn(_ sender: Any) {
        guard let slot1_number = slot1.text, !slot1_number.isEmpty,
              let slot2_number = slot2.text, !slot2_number.isEmpty,
              let slot3_number = slot3.text, !slot3_number.isEmpty,
              let slot4_number = slot4.text, !slot4_number.isEmpty
        else {
            present(alert, animated: true)
            return
        }
        let code = slot1_number + slot2_number + slot3_number + slot4_number
        print(code)
        OtpService.shared.verifyOtp(email: userEmail, otp: code) { success, message in
            if success {
                print("Verify OK")
                self.performSegue(withIdentifier: "continue", sender: nil)
            }
            else {
                print("Error:", message)
                DispatchQueue.main.async {
                    self.present(self.verifyAlertFail, animated: true)
                    self.slot1.text = ""
                    self.slot2.text = ""
                    self.slot3.text = ""
                    self.slot4.text = ""
                }
            }
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func sendOTP(_ userEmail: String) {
        OtpService.shared.sendOtp(email: userEmail) { success, message in
            if success {
                print("OTP sent:", message)
                DispatchQueue.main.async {
                    self.present(self.sentAlertOK, animated: true)
                }
            } else {
                print("Error:", message)
                DispatchQueue.main.async {
                    self.present(self.sentAlertFail, animated: true)
                }
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        textField.text = string
        if textField == slot1 {
            slot2.becomeFirstResponder()
        }
        else if textField == slot2 {
            slot3.becomeFirstResponder()
        }
        else if textField == slot3 {
            slot4.becomeFirstResponder()
        }
        else if textField == slot4 {
            textField.resignFirstResponder()
        }
        return false
    }
}
