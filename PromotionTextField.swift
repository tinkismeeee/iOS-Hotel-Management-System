//
//  PromotionTextField.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 23/3/26.
//

import UIKit

class PromotionTextField : UITextField, UITextFieldDelegate {
    private let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 12)
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        let placeholderText = placeholder ?? ""
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: (UIColor(named: "Placeholder Color") ?? .systemGray),
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
        )
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
