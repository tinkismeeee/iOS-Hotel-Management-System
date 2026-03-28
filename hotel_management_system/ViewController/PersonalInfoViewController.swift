//
//  PersonalInfoViewController.swift
//  hotel_management_system
//
//  Created by mac on 29/3/26.
//

import UIKit

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }

    private func loadUserInfo() {
        let firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
        let lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
        let fullName = [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let email = UserDefaults.standard.string(forKey: "email") ?? "N/A"
        let phone = UserDefaults.standard.string(forKey: "phone") ?? "N/A"
        let address = UserDefaults.standard.string(forKey: "address") ?? "N/A"
        let username = UserDefaults.standard.string(forKey: "username") ?? "N/A"
        let dob = UserDefaults.standard.string(forKey: "date_of_birth") ?? "N/A"

        fullNameLabel.text = "Full Name: \(fullName.isEmpty ? "N/A" : fullName)"
        emailLabel.text = "Email: \(email)"
        phoneLabel.text = "Phone: \(phone)"
        addressLabel.text = "Address: \(address)"
        usernameLabel.text = "Username: \(username)"
        dobLabel.text = "Date of Birth: \(formatDate(dob))"
    }

    private func formatDate(_ isoString: String) -> String {
        guard !isoString.isEmpty, isoString != "N/A" else { return "N/A" }

        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: isoString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        }

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
}
