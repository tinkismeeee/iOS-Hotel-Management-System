import UIKit

class CircleAvatar: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}
