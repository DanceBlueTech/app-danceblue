//
//  RaveHourViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 2/1/18.
//  Copyright © 2018 DanceBlue. All rights reserved.
//

import UIKit

protocol RaveDelegate: class {
    func closeTapped()
}

class RaveHourViewController: UIViewController {
    
    
    let colors = [Theme.Color.Rave.blue, Theme.Color.Rave.red, Theme.Color.Rave.green]
    let labelColors = [Theme.Color.Rave.green, Theme.Color.Rave.blue, Theme.Color.Rave.red]
    
    private var timer: Timer?
    private var i = 0
    
    weak var delegate: RaveDelegate?
    
    @IBOutlet weak var raveLabel: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        startRave()
    }
    
    func startRave() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
    }
    
    @objc func changeColor() {
        raveLabel.isHidden = true
        view.backgroundColor = colors[i]
        if i == 2 {
            i = 0
        } else {
            i += 1
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeTapped(_ sender: Any) {
        delegate?.closeTapped()
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.raveLabel.isHidden = false
        }
        
    }
    
}

