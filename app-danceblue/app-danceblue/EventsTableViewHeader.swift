//
//  EventsTableViewHeader.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/26/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class EventsTableViewHeader: UIView {

    let headerLabel = UILabel()
    let underlineView = UIView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        self.addSubview(headerLabel)
        self.addSubview(underlineView)
        headerLabel.font = Theme.Font.header
        headerLabel.textColor = Theme.Color.black
        underlineView.backgroundColor = Theme.Color.main
        self.backgroundColor = Theme.Color.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        headerLabel.frame.size.height = 25.0
        headerLabel.frame.size.width = self.frame.width - 40.0
        headerLabel.frame.origin.x = 20.0
        headerLabel.frame.origin.y = 8.0
        headerLabel.sizeToFit()
        
        underlineView.frame.size.height = 2.0
        underlineView.frame.size.width = headerLabel.frame.width
        underlineView.frame.origin.y = headerLabel.frame.maxY + 2.0
        underlineView.frame.origin.x = 20.0
    }
    
    func configure(with title: String) {
        headerLabel.text = title
        setupViews()
    }

}
