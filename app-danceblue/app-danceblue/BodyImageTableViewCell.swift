//
//  BodyImageTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/3/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Gifu
import Kingfisher
import UIKit


class BodyImageTableViewCell: UITableViewCell {
    
    static let identifier = "BodyImageCell"
    
    fileprivate var data: BCBodyImage?

    @IBOutlet weak var bodyImageView: GIFImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyImageView.clipsToBounds = true
        bodyImageView.backgroundColor = Theme.Color.background
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bodyImageView.prepareForReuse()
        bodyImageView.image = nil
    }
    
    func configureCell(with data: BCBodyImage) {
        self.data = data
        descriptionLabel.text = data.description
        setupViews()
    }
    
    func setupViews() {
        guard let data = data else { return }
        bodyImageView.kf.setImage(with: URL(string: data.image ?? ""))
    }

    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let adjustedHeight = descriptionLabel.sizeThatFits(CGSize(width: size.width - 40.0, height: size.height)).height + bodyImageView.frame.height + 12.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
}
