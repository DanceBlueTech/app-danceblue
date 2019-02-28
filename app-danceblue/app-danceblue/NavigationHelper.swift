//
//  NavigationHelper.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/25/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Foundation
import UIKit

func setUpNavigation(controller: UINavigationController?, hidesBar: Bool) {
    guard let navigation = controller?.navigationBar else { return }
    controller?.hidesBarsOnTap = hidesBar
    controller?.hidesBarsOnSwipe = hidesBar
    navigation.tintColor = Theme.Color.black
    navigation.titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy), NSAttributedString.Key.foregroundColor : Theme.Color.black]
    navigation.isTranslucent = true
    navigation.barTintColor = Theme.Color.white
}
