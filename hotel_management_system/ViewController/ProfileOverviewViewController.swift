//
//  ProfileOverviewViewController.swift
//  hotel_management_system
//
//  Created by mac on 29/3/26.
//

import UIKit

class ProfileOverviewViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProfileData()
    }

    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }

    private func loadProfileData() {
        let firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
        let lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
        let fullName = [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        nameLabel.text = fullName.isEmpty ? "Guest User" : fullName

        if let avatarData = UserDefaults.standard.data(forKey: "avatar_image"),
           let image = UIImage(data: avatarData) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage(named: "avt")
        }
    }
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(
                title: "Logout",
                message: "Sure?",
                preferredStyle: .alert
            )

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginNav = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = loginNav
                    window.makeKeyAndVisible()
                }
            }

            alert.addAction(cancelAction)
            alert.addAction(logoutAction)

            present(alert, animated: true)
    }
    
}
