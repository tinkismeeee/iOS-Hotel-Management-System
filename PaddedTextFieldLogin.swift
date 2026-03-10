import UIKit

class PaddedTextFieldLogin: UITextField, UITextFieldDelegate {

    private let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 12)
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 0
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
