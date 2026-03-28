//
//  AvatarViewController.swift
//  hotel_management_system
//
//  Created by mac on 29/3/26.
//

import UIKit

class AvatarViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAvatar()
    }

    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        titleLabel.text = "Profile Avatar"
    }

    private func loadAvatar() {
        if let avatarData = UserDefaults.standard.data(forKey: "avatar_image"),
           let image = UIImage(data: avatarData) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage(named: "avt")
        }
    }
}
