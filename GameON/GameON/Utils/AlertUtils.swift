//
//  AlertUtils.swift
//  GameON
//
//  Created by Atharian Rahmadani on 04/10/24.
//

import Foundation
import UIKit

final class AlertUtils {
    static func showErrorAlert(
        on viewController: UIViewController,
        errorMessage: String,
        completion: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: "Oops...",
            message: errorMessage,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { _ in
            completion()
        }))

        viewController.present(alert, animated: true, completion: nil)
    }
}
