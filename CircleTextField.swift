import UIKit

class CircleTextField: UITextField, UITextFieldDelegate {

    private let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self

        borderStyle = .none
        clipsToBounds = true

        let placeholderText = placeholder ?? ""
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
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
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 1
    }
}
