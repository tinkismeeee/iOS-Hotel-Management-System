import UIKit

class Icon: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}
