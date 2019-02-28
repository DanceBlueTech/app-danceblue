//
//  QuoteTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/1/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    static let identifier = "QuoteCell"
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteIcon: UIImageView!
    
    private var data: BCQuote?
    
    // MARK: - Initialization
    
    func configureCell(with data: BCQuote) {
        self.data = data
        setupViews()
    }
    
    func setupViews() {
        quoteLabel.text = data?.quote
        quoteIcon.image = #imageLiteral(resourceName: "pull-quote")
    }

    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {        
        let adjustedHeight = 28.0 + quoteIcon.frame.height + quoteLabel.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height
        return CGSize(width: size.width, height: adjustedHeight)
    }

}
