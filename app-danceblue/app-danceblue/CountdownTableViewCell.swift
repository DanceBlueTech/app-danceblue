//
//  CountdownTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/13/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

class CountdownTableViewCell: UITableViewCell {

    static let identifier = "CountdownCell"
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownImageView: UIImageView!
    
    @IBOutlet weak var daysNumberLabel: UILabel!
    @IBOutlet weak var hoursNumberLabel: UILabel!
    @IBOutlet weak var minutesNumberLabel: UILabel!
    @IBOutlet weak var secondsNumberLabel: UILabel!
    
    @IBOutlet weak var daysTextLabel: UILabel!
    @IBOutlet weak var hoursTextLabel: UILabel!
    @IBOutlet weak var minutesTextLabel: UILabel!
    @IBOutlet weak var secondsTextLabel: UILabel!

    @IBOutlet weak var daysRoundedView: UIView!
    @IBOutlet weak var hoursRoundedView: UIView!
    @IBOutlet weak var minutesRoundedView: UIView!
    @IBOutlet weak var secondsRoundedView: UIView!
    
    private var countdownImage: String?
    private var countdownTimer: Timer?
    private var countdownDate: Date? {
        didSet {
            setupCountdown()
            //log.debug("Timer Started")
        }
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        countdownImageView.backgroundColor = Theme.Color.background
        
        daysRoundedView.layer.cornerRadius = 5.0
        hoursRoundedView.layer.cornerRadius = 5.0
        minutesRoundedView.layer.cornerRadius = 5.0
        secondsRoundedView.layer.cornerRadius = 5.0
        
        daysRoundedView.clipsToBounds = true
        hoursRoundedView.clipsToBounds = true
        minutesRoundedView.clipsToBounds = true
        secondsRoundedView.clipsToBounds = true
    }
    
    func configureCell(with date: Date?, title: String?, image: String?) {
        countdownDate = date
        titleLabel.text = title
        
        guard let image = image else { return }
        countdownImageView.kf.setImage(with: URL(string: image))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 10.0 + titleLabel.frame.height + 15.0 + daysRoundedView.frame.height
        adjustedHeight += daysTextLabel.frame.height + 10.0 + logoImageView.frame.height + 20.0
        return CGSize(width: size.width, height: adjustedHeight)
    }
    
    func setupCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        guard let countdownDate = countdownDate else { return }
        let components = Calendar.current.dateComponents([.day, .hour,.minute,.second], from: Date(), to: countdownDate)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        if days <= 0, hours <= 0, minutes <= 0, seconds <= 0 {
            countdownTimer?.invalidate()
        } else {
            daysTextLabel.text = days != 1 ? "Days" : "Day"
            hoursTextLabel.text = hours != 1 ? "Hours" : "Hour"
            minutesTextLabel.text = minutes != 1 ? "Minutes" : "Minute"
            secondsTextLabel.text = seconds != 1 ? "Seconds" : "Second"
            
            daysNumberLabel.text = "\(days)"
            hoursNumberLabel.text = "\(hours)"
            minutesNumberLabel.text = "\(minutes)"
            secondsNumberLabel.text = "\(seconds)"
        }
    }
    
}
