//
//  RightsResponsibilitiesViewController.swift
//  hotel_management_system
//

import UIKit

class RightsResponsibilitiesViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }

    private func setupContent() {
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 18)
        textView.text = """
        1. Members have the right to use hotel services according to booking policies.

        2. Members must provide accurate and truthful personal information.

        3. Members are responsible for preserving hotel property during their stay.

        4. Payment, refund, and cancellation policies are applied according to each booking.

        5. Members must comply with hotel regulations to ensure safety and comfort for everyone.

        6. For complaints, disputes, or support requests, please contact the Help & Support section.
        """
    }
}
