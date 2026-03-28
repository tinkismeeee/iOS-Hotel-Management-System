//
//  BankCardsViewController.swift
//  hotel_management_system
//

import UIKit

class BankCardsViewController: UIViewController {

    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardHolderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMockCard()
    }

    private func loadMockCard() {
        let firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
        let lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
        let fullName = [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .uppercased()

        cardTypeLabel.text = "VISA"
        cardNumberLabel.text = "**** **** **** 4821"
        cardHolderLabel.text = fullName.isEmpty ? "CARD HOLDER" : fullName
    }
}
