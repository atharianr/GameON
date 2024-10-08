//
//  ProfileViewController.swift
//  GameON
//
//  Created by Atharian Rahmadani on 26/09/24.
//

import UIKit
import Profile

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileBannerImageView: UIImageView!

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var profileDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }

    @IBAction func onEditClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "moveToEditProfile", sender: self)
    }

    private func setupView() {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.colorPrimary.cgColor
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true

        editButton.tintColor = .colorPrimary
    }

    private func bindData() {
        ProfileModel.synchronize()

        profileBannerImageView.image = UIImage(data: ProfileModel.image)
        profileImageView.image = UIImage(data: ProfileModel.image)
        profileNameLabel.text = "\(ProfileModel.name)"
        profileDescriptionLabel.text = "\(ProfileModel.occupation) at \(ProfileModel.organization)"
    }
}
