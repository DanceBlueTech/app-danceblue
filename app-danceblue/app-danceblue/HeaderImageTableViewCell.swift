//
//  HeaderImageTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/1/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class HeaderImageTableViewCell: UITableViewCell {

    static let identifier = "HeaderImageCell"
    
    private var data: BCHeaderImage?
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImageView.clipsToBounds = true
        headerImageView.backgroundColor = Theme.Color.background
    }
    
    func configureCell(with data: BCHeaderImage) {
        self.data = data
        descriptionLabel.text = data.description
        headerImageView.kf.setImage(with: URL(string: data.image ?? ""))
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let header = headerImageView else { return CGSize() }
        let height: CGFloat = descriptionLabel.sizeThatFits(CGSize(width: size.width - 40.0, height: .greatestFiniteMagnitude)).height + header.frame.height + 8.0 + 8.0 + 8.0
        return CGSize(width: bounds.width, height: height)
    }
    
}
