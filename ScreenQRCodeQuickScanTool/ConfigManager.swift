//
//  ConfigManager.swift
//  ScreenQRCodeQuickScanTool
//
//  Created by CYC on 2018/11/20.
//  Copyright © 2018 west2. All rights reserved.
//

import Cocoa

class ConfigManager{
    static var autoOpenUrl:Bool {
        get {
            return UserDefaults.standard.bool(forKey: "KAutoOpenUrl")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "KAutoOpenUrl")
        }
    }
    
    static var autoCopyQRs:Bool {
        get {
            return UserDefaults.standard.bool(forKey: "autoCopyQRs")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoCopyQRs")
        }
    }
}
