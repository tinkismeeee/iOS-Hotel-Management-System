//
//  LoginViewController.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 5/2/26.
//
import Alamofire
import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var remember: RadioButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    var loginSuccess = false
    var isRemember = false
    let alert = UIAlertController(title: "Error", message: "Email or password is invalid", preferredStyle: .alert)
    let loginInfo = UserDefaults.standard
    var userId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in print("")
        }
        alert.addAction(okAction)
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "enterotp" {
            return loginSuccess
        }
        return true
    }
    
    @IBAction func rememberBtn(_ sender: Any) {
        isRemember.toggle()
    }
    @IBAction func btnLoginTapped(_ sender: Any) {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        
        if (email.isEmpty || password.isEmpty) {
            present(alert, animated: true, completion: nil)
//            self.loginInfo.set("tinhisme1@gmail.com", forKey: "email")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "HomeNav")
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
            return
        }
        else {
            let body = LoginModel(email: email, password: password)
            Service.shared.login(body: body) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        print(String(data: data, encoding: .utf8) ?? "")
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let user = json["user"] as? [String: Any],
                               let userId = user["user_id"] as? Int {
                                DispatchQueue.main.async {
                                    self.loginSuccess = true
                                    self.emailInput.text = ""
                                    self.passwordInput.text = ""
                                    self.loginInfo.set(email, forKey: "email")
                                    self.loginInfo.set(password, forKey: "password")
                                    self.loginInfo.set(userId, forKey: "userId")
                                    self.loginInfo.set(user["first_name"] as? String, forKey: "name")
                                    self.loginInfo.set(user["address"] as? String, forKey: "address")
                                    self.performSegue(withIdentifier: "enterotp", sender: email)
                                    self.loginSuccess = false
                                }
                            } else {
                                print("user_id not found")
                            }
                        } catch {
                            print("Parse error: \(error)")
                        }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.loginSuccess = false
                        self.present(self.alert, animated: true, completion: nil)
                        self.emailInput.text = ""
                        self.passwordInput.text = ""
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
