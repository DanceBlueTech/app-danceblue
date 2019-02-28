//
//  QuestionTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/25/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    static let identifier = "QuestionCell"
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionLabel.font = Theme.Font.header
        underlineView.backgroundColor = Theme.Color.main
    }
    
    func configureCell(with data: [String : String]) {
        questionLabel.text = data["question"]
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 20.0 + questionLabel.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude)).height)
    }

}
