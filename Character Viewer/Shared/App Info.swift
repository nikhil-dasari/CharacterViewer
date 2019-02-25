//
//  App Info.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/24/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation

class AppInfo {
  
    enum AppType: String {
        case simpsons = "Simpsons Character Viewer"
        case wire = "The Wire Character Viewer"
    }

    fileprivate static var currentApp: AppType = .simpsons
    
    static var appName: String? {
        let currentAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        if currentAppName == AppType.simpsons.rawValue {
            currentApp = .simpsons
        }else {
            currentApp = .wire
        }
        return currentAppName
    }
    
    static var characterViewerServiceUrl: URL? {
        switch currentApp {
        case .simpsons:
            return URL(string: "http://api.duckduckgo.com/?q=simpsons+characters&format=json")
        case .wire:
            return URL(string: "http://api.duckduckgo.com/?q=the+wire+characters&format=json")
        }
    }
    
}

