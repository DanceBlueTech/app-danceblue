//
//  DispatchQueue+Sync.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/8/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    class func syncUpdateOnMain(_ block: @escaping ()->()) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.sync {
                block()
            }
        }
    }
    
}
