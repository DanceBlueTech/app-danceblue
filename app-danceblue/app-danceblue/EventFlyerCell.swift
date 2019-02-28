//
//  EventFlyerCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 11/3/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class EventFlyerCell: UITableViewCell {
    
    static let identifier = "EventFlyerCell"
    
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flyerImageView: UIImageView!
    
    fileprivate var event: Event?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        underlineView.backgroundColor = Theme.Color.main
        titleLabel.font = Theme.Font.header
        titleLabel.text = "FLYER"
        flyerImageView.clipsToBounds = true
    }
    
    func configureCell(with event: Event) {
        self.event = event
        flyerImageView.kf.setImage(with: URL(string: event.flyer ?? ""))
        
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 8.0 + titleLabel.frame.height + 2.0
        adjustedHeight += underlineView.frame.height + 16.0 + flyerImageView.frame.height + 16.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
}
