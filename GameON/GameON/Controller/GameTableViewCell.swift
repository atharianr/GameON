//
//  GameTableViewCell.swift
//  GameON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet var gameImage: UIImageView!

    @IBOutlet var cardView: UIView!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var ratingLabel: UILabel!

    @IBOutlet var releaseDateLabel: UILabel!

    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!
}
