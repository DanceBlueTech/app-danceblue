//
//  FloorPlanTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 2/4/18.
//  Copyright © 2018 DanceBlue. All rights reserved.
//

import UIKit

class FloorPlanTableViewCell: UITableViewCell {

    static let identifier = "FloorPlanCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var floorPlanImageView: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        floorPlanImageView.layer.cornerRadius = 5.0
        floorPlanImageView.clipsToBounds = true
        floorPlanImageView.image = #imageLiteral(resourceName: "DB_FloorMap")
        titleLabel.font = Theme.Font.header
    }
    
}
