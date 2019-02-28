//
//  EventHeaderCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/18/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Kingfisher
import UIKit

protocol EventHeaderDelegate: class {
    func heartButton(didChangeValueFor event: Event, value: Int)
}

class EventHeaderCell: UITableViewCell {
    
    static let identifier = "EventHeaderCell"
    
    // Used for "going" section on events
    
    /*
    let gradient = CAGradientLayer()
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var numberGoingLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
     */
    
    
    @IBOutlet weak var headerImageView: UIImageView!

   
    fileprivate var event: Event?
    
    weak var delegate: EventHeaderDelegate?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        headerImageView.clipsToBounds = true
        headerImageView.backgroundColor = Theme.Color.background
        //setupGradient() // Used for "going" section on events
    }
    
    func configureCell(with event: Event) {
        self.event = event
        headerImageView.kf.setImage(with: URL(string: event.image ?? ""))
    }
    
    // MARK: - Gradient
    // Desccription: Used for UI for going section on Events
    
    /*
    func setupGradient() {
        gradient.frame = gradientView.frame
        gradientView.layer.addSublayer(gradient)
        gradient.colors = [Theme.Color.black, Theme.Color.clear]
    }
    */
    
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let header = headerImageView else { return CGSize() }
        let height: CGFloat = header.frame.height + 8.0
        return CGSize(width: bounds.width, height: height)
    }

    /*
    @IBAction func heartTapped(_ sender: Any) {
        
        guard let event = event else { return }
        
        if heartButton.imageView?.image == #imageLiteral(resourceName: "heart-outline") {
            heartButton.setImage(#imageLiteral(resourceName: "heart-fill"), for: .normal)
            delegate?.heartButton(didChangeValueFor: event, value: +1)
        } else if heartButton.imageView?.image == #imageLiteral(resourceName: "heart-fill") {
            heartButton.setImage(#imageLiteral(resourceName: "heart-outline"), for: .normal)
            delegate?.heartButton(didChangeValueFor: event, value: -1)
        }
    }
    */
    
}

