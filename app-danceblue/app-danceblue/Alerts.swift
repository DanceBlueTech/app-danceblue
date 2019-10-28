//
//  Alerts.swift
//  app-danceblue
//
//  Created by David Mercado on 10/28/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import UIKit

// MARK: Helper Extensions
extension UIViewController {
  func showAlert(withTitle title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
