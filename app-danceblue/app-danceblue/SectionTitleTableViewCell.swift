//
//  SectionTitleTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/4/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {
    
    static let identifier = "SectionTitleCell"
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    private var data: BCSectionTitle?
    
    // MARK: - Initialization
    
    func configureCell(with data: BCSectionTitle) {
        self.data = data
        setupViews()
    }
    
    func setupViews() {
        sectionTitleLabel.text = data?.title
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let adjustedHeight = 16.0 + sectionTitleLabel.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
}
