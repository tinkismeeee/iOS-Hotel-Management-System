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
//            present(alert, animated: true, completion: nil)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "home")
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
                        DispatchQueue.main.async {
                            self.loginSuccess = true
                            self.emailInput.text = ""
                            self.passwordInput.text = ""
                            self.loginInfo.set(email, forKey: "email")
                            self.loginInfo.set(password, forKey: "password")
                            self.performSegue(withIdentifier: "enterotp", sender: email)
                            self.loginSuccess = false
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
