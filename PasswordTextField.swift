import UIKit

class PasswordTextField: UITextField, UITextFieldDelegate{

    private let toggleButton = UIButton(type: .custom)

    private let contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 44)

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        setupUI()
        setupToggleButton()
    }

    // MARK: - UI Setup
    private func setupUI() {
        borderStyle = .none
        layer.cornerRadius = 10
        clipsToBounds = true

        let placeholderText = placeholder ?? ""
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor(named: "Placeholder Color") ?? .systemGray,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
        )

        isSecureTextEntry = true
    }

    private func setupToggleButton() {
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        toggleButton.setImage(UIImage(named: "eye_slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)

        rightView = toggleButton
        rightViewMode = .always
    }

    // MARK: - Toggle Password
    @objc private func togglePassword() {
        let wasFirstResponder = isFirstResponder
        resignFirstResponder()

        isSecureTextEntry.toggle()

        if wasFirstResponder {
            becomeFirstResponder()
        }

        let imageName = isSecureTextEntry ? "eye_slash" : "eye"
        toggleButton.setImage(UIImage(named: imageName), for: .normal)
    }

    // MARK: - Padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    // MARK: - Right View Position
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size: CGFloat = 24
        return CGRect(
            x: bounds.width - size - 16,
            y: (bounds.height - size) / 2,
            width: size,
            height: size
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
