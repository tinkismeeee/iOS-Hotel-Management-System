//
//  PromotionApplyButton.swift
//  hotel_management_system
//
//  Created by umtlab03im01 on 23/3/26.
//

import UIKit
class PromotionApplyButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
