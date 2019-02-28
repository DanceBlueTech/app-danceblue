//
//  DonateTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/20/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class DonateTableViewCell: UITableViewCell {

    static let identifier = "DonateCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var donateImageView: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        donateImageView.layer.cornerRadius = 5.0
        donateImageView.clipsToBounds = true
        donateImageView.image = #imageLiteral(resourceName: "DanceBlueReveal")
        titleLabel.text = "DONATE"
        titleLabel.font = Theme.Font.header
    }
    
}


