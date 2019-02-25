//
//  Device Info.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/24/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfo {
    
    static var isPhone: Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return true
        default:
            return false
        }
    }
    
}
