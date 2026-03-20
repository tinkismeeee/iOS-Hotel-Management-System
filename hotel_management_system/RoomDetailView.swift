//
//  RoomDetailView.swift
//  hotel_management_system
//
//  Created by mac on 20/3/26.
//
import UIKit

class RoomDetailView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
        
    func setupView() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
}
