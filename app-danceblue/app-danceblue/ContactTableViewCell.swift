//
//  ContactTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/26/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier = "ContactCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        contactImageView.layer.cornerRadius = 5.0
        contactImageView.clipsToBounds = true
        contactImageView.image = #imageLiteral(resourceName: "Contact")
        titleLabel.text = "CONTACT"
        titleLabel.font = Theme.Font.header
    }
    
}
