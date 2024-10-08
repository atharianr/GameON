//
//  EditProfileViewController.swift
//  GameON
//
//  Created by Atharian Rahmadani on 02/10/24.
//

import UIKit
import Profile
import Combine

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var occupationTextField: UITextField!

    @IBOutlet weak var organizationTextField: UITextField!

    private let imagePicker = UIImagePickerController()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupForm()
    }

    @IBAction func onSaveClicked(_ sender: UIButton) {
        showSaveAlert()
    }

    @IBAction func showTextFieldNotComplete(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Incomplete Information",
            message: "Please ensure all required fields are filled in correctly.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }

    @objc func imageClicked() {
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func setupView() {
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.colorPrimary.cgColor
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTapGesture)

        saveButton.tintColor = .colorPrimary

        let textFields: [UITextField] = [nameTextField, occupationTextField, organizationTextField]
        for textField in textFields {
            setupTextFields(for: textField)
        }
    }

    private func setupForm() {
        ProfileModel.synchronize()

        profileImageView.image = UIImage(data: ProfileModel.image)
        nameTextField.text = ProfileModel.name
        occupationTextField.text = ProfileModel.occupation
        organizationTextField.text = ProfileModel.organization

        setupCombine()
    }

    private func setupTextFields(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        if #available(iOS 15.0, *) {
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -16, bottom: 0, trailing: 0)
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        }
        button.frame = CGRect(
            x: CGFloat(nameTextField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )
        button.addTarget(self, action: #selector(self.showTextFieldNotComplete(_:)), for: .touchUpInside)

        textField.rightView = button
    }

    func setupCombine() {
        // Name
        let nameStream = nameTextField.textPublisher
            .map { !$0.isEmpty }

        nameStream
            .sink { value in
                self.nameTextField.rightViewMode = value ? .never : .always
            }
            .store(in: &cancellables)

        // Occupation
        let occupationStream = occupationTextField.textPublisher
            .map { !$0.isEmpty }

        occupationStream
            .sink { value in
                self.occupationTextField.rightViewMode = value ? .never : .always
            }
            .store(in: &cancellables)

        // Organization
        let organizationStream = organizationTextField.textPublisher
            .map { !$0.isEmpty }

        organizationStream
            .sink { value in
                self.organizationTextField.rightViewMode = value ? .never : .always
            }
            .store(in: &cancellables)

        // Combine the streams
        Publishers.CombineLatest3(nameStream, occupationStream, organizationStream)
            .map { name, occupation, organization in
                name && occupation && organization
            }
            .sink { isValid in
                debugPrint("isValid \(isValid)")
                self.saveButton.isEnabled = isValid
                self.saveButton.tintColor = isValid ? .colorPrimary : UIColor.systemGray
            }
            .store(in: &cancellables)
    }

    private func showSaveAlert() {
        if let image = profileImageView.image, let data = image.pngData() {
            let alert = UIAlertController(
                title: "Warning",
                message: "Do you want to save your profile changes?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                let name = self.nameTextField.text ?? ""
                let occupation = self.occupationTextField.text ?? ""
                let organization = self.organizationTextField.text ?? ""

                self.saveData(name: name, occupation: occupation, organization: organization, image: data)
                self.navigationController?.popViewController(animated: true)
            })

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    private func saveData(name: String, occupation: String, organization: String, image: Data) {
        ProfileModel.name = name
        ProfileModel.occupation = occupation
        ProfileModel.organization = organization
        ProfileModel.image = image
    }

    private func alert(_ message: String) {
        let allertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        allertController.addAction(alertAction)
        self.present(allertController, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Failed",
                message: "Image can't be loaded.",
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
