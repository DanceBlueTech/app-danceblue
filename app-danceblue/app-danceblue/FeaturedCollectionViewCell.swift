//
//  FeaturedCollectionViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/31/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturedCell"
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var featuredUnderlineView: UIView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var recentUnderlineView: UIView!
    
    private var details: BlogDetails?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        featuredImageView.layer.cornerRadius = 10.0
        featuredImageView.clipsToBounds = true
        featuredImageView.backgroundColor = Theme.Color.background
        
        featuredLabel.font = Theme.Font.header
        featuredLabel.textColor = Theme.Color.black
        featuredUnderlineView.backgroundColor = Theme.Color.main
        
        recentLabel.font = Theme.Font.header
        recentLabel.textColor = Theme.Color.black
        recentUnderlineView.backgroundColor = Theme.Color.main
    }
    
    func configureCell(with details: BlogDetails) {
        self.details = details
        updateWithContent()
    }
    
    func updateWithContent() {
        authorLabel.text = details?.author
        titleLabel.text = details?.title
        featuredImageView.kf.setImage(with: URL(string: details?.image ?? ""))
    }
    
}
