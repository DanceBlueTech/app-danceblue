//
//  EventMapCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/21/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class EventMapCell: UITableViewCell {
    
    static let identifier = "EventMapCell"
    
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    
    let tapRecognizer = UITapGestureRecognizer()
    fileprivate var event: Event?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        underlineView.backgroundColor = Theme.Color.main
        titleLabel.font = Theme.Font.header
        titleLabel.text = "DIRECTIONS"
        mapImageView.clipsToBounds = true
        mapImageView.layer.cornerRadius = 10.0
        mapImageView.backgroundColor = Theme.Color.background
        tapRecognizer.addTarget(self, action: #selector(mapTapped))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func configureCell(with event: Event) {
        self.event = event
        mapImageView.kf.setImage(with: URL(string: event.map ?? ""))
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 8.0 + titleLabel.frame.height + 2.0 + underlineView.frame.height
        adjustedHeight += 16.0 + mapImageView.frame.height + 16.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
    // MARK: - Action
    
    @objc func mapTapped() {
        if event?.address != nil {
            UIApplication.shared.open(Router.Maps.buildAddressURL(from: (event?.address)!), options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
