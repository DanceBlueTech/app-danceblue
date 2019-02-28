//
//  MoraleCupTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 1/31/18.
//  Copyright © 2018 DanceBlue. All rights reserved.
//

import UIKit

class MoraleCupTableViewCell: UITableViewCell {

    static let identifier = "MoraleCupCell"
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var firstPlaceTeamNumberLabel: UILabel!
    @IBOutlet weak var firstPlaceTeamNameLabel: UILabel!
    @IBOutlet weak var firstPlaceTeamPointsLabel: UILabel!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var secondPlaceTeamNumberLabel: UILabel!
    @IBOutlet weak var secondPlaceTeamNameLabel: UILabel!
    @IBOutlet weak var secondPlaceTeamPointsLabel: UILabel!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceTeamNumberLabel: UILabel!
    @IBOutlet weak var thirdPlaceTeamNameLabel: UILabel!
    @IBOutlet weak var thirdPlaceTeamPointsLabel: UILabel!
    
    @IBOutlet weak var fourthPlaceLabel: UILabel!
    @IBOutlet weak var fourthPlaceTeamNumberLabel: UILabel!
    @IBOutlet weak var fourthPlaceTeamNameLabel: UILabel!
    @IBOutlet weak var fourthPlaceTeamPointsLabel: UILabel!
    
    @IBOutlet weak var fifthPlaceLabel: UILabel!
    @IBOutlet weak var fifthPlaceTeamNumberLabel: UILabel!
    @IBOutlet weak var fifthPlaceTeamNameLabel: UILabel!
    @IBOutlet weak var fifthPlaceTeamPointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupStyles()
    }

    // MARK: - Initialization
    
    func configureCell(with data: [MoraleTeam]) {
        setupStyles()
        if data.count >= 5 {
            configureFirstPlace(with: data)
            configureSecondPlace(with: data)
            configureThirdPlace(with: data)
            configureFourthPlace(with: data)
            configureFifthPlace(with: data)
        }
    }
    
    
    func configureFirstPlace(with data: [MoraleTeam]) {
        firstPlaceLabel.text = "1"
        firstPlaceTeamNumberLabel.text = data[0].name ?? ""
        firstPlaceTeamNameLabel.text = "Team \(data[0].number ?? 0)"
        firstPlaceTeamPointsLabel.text = "\(data[0].points ?? 0) points"
    }
    
    func configureSecondPlace(with data: [MoraleTeam]) {
        secondPlaceLabel.text = "2"
        secondPlaceTeamNumberLabel.text = data[1].name ?? ""
        secondPlaceTeamNameLabel.text = "Team \(data[1].number ?? 0)"
        secondPlaceTeamPointsLabel.text = "\(data[1].points ?? 0) points"
    }
    
    func configureThirdPlace(with data: [MoraleTeam]) {
        thirdPlaceLabel.text = "3"
        thirdPlaceTeamNumberLabel.text = data[2].name ?? ""
        thirdPlaceTeamNameLabel.text = "Team \(data[2].number ?? 0)"
        thirdPlaceTeamPointsLabel.text = "\(data[2].points ?? 0) points"
    }
    
    func configureFourthPlace(with data: [MoraleTeam]) {
        fourthPlaceLabel.text = "4"
        fourthPlaceTeamNameLabel.text = "Team \(data[3].number ?? 0)"
        fourthPlaceTeamNumberLabel.text = data[3].name ?? ""
        fourthPlaceTeamPointsLabel.text = "\(data[3].points ?? 0) points"
    }
    
    func configureFifthPlace(with data: [MoraleTeam]) {
        fifthPlaceLabel.text = "5"
        fifthPlaceTeamNameLabel.text = "Team \(data[4].number ?? 0)"
        fifthPlaceTeamNumberLabel.text = data[4].name ?? ""
        fifthPlaceTeamPointsLabel.text = "\(data[4].points ?? 0) points"
    }
    
    // MARK: - Styling
    
    func setupStyles() {
        styleFirst()
        styleSecond()
        styleThird()
        styleFourth()
        styleFifth()
    }
    
    // blue, red, white, yellow, green
    
    func styleFirst() {
        firstPlaceLabel.backgroundColor = Theme.Color.Rave.blue
        firstPlaceLabel.layer.cornerRadius = firstPlaceLabel.frame.size.width / 2
        firstPlaceLabel.clipsToBounds = true
        firstPlaceLabel.font = Theme.Font.MoraleCup.bold
        firstPlaceLabel.textColor = Theme.Color.white
        
        firstPlaceTeamNumberLabel.textColor = Theme.Color.black
        firstPlaceTeamNameLabel.textColor = Theme.Color.black
        firstPlaceTeamPointsLabel.textColor = Theme.Color.black
    }
    
    func styleSecond() {
        secondPlaceLabel.backgroundColor = Theme.Color.Rave.red
        secondPlaceLabel.layer.cornerRadius = firstPlaceLabel.frame.size.width / 2
        secondPlaceLabel.clipsToBounds = true
        secondPlaceLabel.font = Theme.Font.MoraleCup.bold
        secondPlaceLabel.textColor = Theme.Color.white
        
        secondPlaceTeamNumberLabel.textColor = Theme.Color.black
        secondPlaceTeamNameLabel.textColor = Theme.Color.black
        secondPlaceTeamPointsLabel.textColor = Theme.Color.black
    }
    
    func styleThird() {
        thirdPlaceLabel.backgroundColor = Theme.Color.black
        thirdPlaceLabel.layer.cornerRadius = firstPlaceLabel.frame.size.width / 2
        thirdPlaceLabel.clipsToBounds = true
        thirdPlaceLabel.font = Theme.Font.MoraleCup.bold
        thirdPlaceLabel.textColor = Theme.Color.white
        
        thirdPlaceTeamNumberLabel.textColor = Theme.Color.black
        thirdPlaceTeamNameLabel.textColor = Theme.Color.black
        thirdPlaceTeamPointsLabel.textColor = Theme.Color.black
    }
    
    func styleFourth() {
        fourthPlaceLabel.backgroundColor = Theme.Color.Rave.yellow
        fourthPlaceLabel.layer.cornerRadius = firstPlaceLabel.frame.size.width / 2
        fourthPlaceLabel.clipsToBounds = true
        fourthPlaceLabel.font = Theme.Font.MoraleCup.bold
        fourthPlaceLabel.textColor = Theme.Color.black
        
        fourthPlaceTeamNumberLabel.textColor = Theme.Color.black
        fourthPlaceTeamNameLabel.textColor = Theme.Color.black
        fourthPlaceTeamPointsLabel.textColor = Theme.Color.black
    }
    
    func styleFifth() {
        fifthPlaceLabel.backgroundColor = Theme.Color.Rave.green
        fifthPlaceLabel.layer.cornerRadius = firstPlaceLabel.frame.size.width / 2
        fifthPlaceLabel.clipsToBounds = true
        fifthPlaceLabel.font = Theme.Font.MoraleCup.bold
        fifthPlaceLabel.textColor = Theme.Color.white
        
        fifthPlaceTeamNumberLabel.textColor = Theme.Color.black
        fifthPlaceTeamNameLabel.textColor = Theme.Color.black
        fifthPlaceTeamPointsLabel.textColor = Theme.Color.black
    }
    
}
