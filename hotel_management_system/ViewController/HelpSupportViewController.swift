//
//  HelpSupportViewController.swift
//  hotel_management_system
//
//  Created by mac on 29/3/26.
//

import UIKit

class HelpSupportViewController: UIViewController {

    @IBOutlet weak var hotlineLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupSupportInfo()
    }

    private func setupSupportInfo() {
        hotlineLabel.text = "Hotline: 1900 1234"
        emailLabel.text = "Email: support@umthotel.com"
        workingHoursLabel.text = "Working hours: 24/7"

    }
}
