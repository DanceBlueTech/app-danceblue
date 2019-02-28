//
//  EventTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/22/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let identifier = "EventCell"
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    fileprivate var event: Event?

    // MARK: - Initialization
    
    override func awakeFromNib() {
        headerImageView.layer.cornerRadius = 10.0
        headerImageView.clipsToBounds = true
        headerImageView.backgroundColor = Theme.Color.background
        self.backgroundColor = Theme.Color.white
        self.selectionStyle = .none
    }
    
    func configureCell(with event: Event) {
        self.event = event
        updateWithContent()
    }

    func updateWithContent() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        titleLabel.text = event?.title
        dateLabel.text = formatter.string(from: event?.timestamp ?? Date())
        if let time = event?.time {
            timeLabel.text = "• \(time)"
        }
        headerImageView.kf.setImage(with: URL(string: event?.image ?? ""))
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let x = 40.0 + headerImageView.frame.height + titleLabel.sizeThatFits(CGSize(width: size.width - 40.0, height: .greatestFiniteMagnitude)).height + dateLabel.sizeThatFits(CGSize(width: size.width - 40.0, height: .greatestFiniteMagnitude)).height
        
        return CGSize(width: size.width, height: x)
    }
    
}

