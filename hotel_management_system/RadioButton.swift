import UIKit

class RadioButton: UIButton {
    public var isRemember: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    private func setupUI() {
        setImage(UIImage(systemName: "circle"), for: .normal)
        setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)

        tintColor = UIColor(named: "Radio Remember Color") ?? .systemBlue

        backgroundColor = .clear
        
        showsTouchWhenHighlighted = false
        adjustsImageWhenHighlighted = false

        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
    }


    @objc private func didTap() {
        isSelected.toggle()
        // print("is selected: \(isSelected)")
        if (isRemember == true) {
            isRemember = isSelected
            print("False")
            return
        }
        isRemember = isSelected
        print("True")
        UIView.animate(withDuration: 0.05) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.transform = .identity
            }
        }
    }
}
