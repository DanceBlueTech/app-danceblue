//
//  SponsorCollectionViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/16/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class SponsorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SponsorCollectionCell"
    
    @IBOutlet weak var sponsorImageView: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        sponsorImageView.backgroundColor = Theme.Color.white
        sponsorImageView.layer.cornerRadius = 5.0
        sponsorImageView.clipsToBounds = true
    }
    
    func configureCell(with sponsor: Sponsor) {
        let url = URL(string: sponsor.image ?? "")
        sponsorImageView.kf.setImage(with: url)
    }
    
}
