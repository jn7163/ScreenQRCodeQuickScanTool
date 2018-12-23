//
//  AppDelegate.swift
//
//
//  Created by CYC on 2018/11/19.
//  Copyright © 2018 west2. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    var statusItem: NSStatusItem!

    @IBOutlet weak var autoOpenUrlMenuItem: NSMenuItem!
    @IBOutlet weak var autoCopyMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength:30)
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: "statusMenuIcon")
        statusItem.button?.image?.isTemplate = true
        updateMenuItemStatus()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func updateMenuItemStatus() {
        autoOpenUrlMenuItem.state = ConfigManager.autoOpenUrl ? .on : .off
        autoCopyMenuItem.state = ConfigManager.autoCopyQRs ? .on : .off

    }
    
    func scanQRCode() {
        guard let qrs = QRCodeUtil.ScanQRCodeOnScreen() else {return}
        let mutileQR = qrs.count > 1
        var stringToCopy = ""
        for each in qrs {
            if let url = URL(string: each) {
                if ConfigManager.autoOpenUrl {
                    NSWorkspace.shared.open(url)
                }
            }
            
            if ConfigManager.autoCopyQRs {
                stringToCopy += each
                if mutileQR {stringToCopy += "\n"}
            }
            
            NSUserNotificationCenter.default.postQRFound(content: each)
        }
        
        if ConfigManager.autoCopyQRs {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(stringToCopy, forType: .string)
        }
        
    }

    @IBAction func actionScanQRCode(_ sender: Any) {
        DispatchQueue.main.async {
            self.scanQRCode()
        }
    }
    
    @IBAction func actionAutoOpenUrl(_ sender: Any) {
        ConfigManager.autoOpenUrl = !ConfigManager.autoOpenUrl
        updateMenuItemStatus()
    }
    
    @IBAction func actionAutoCopyQr(_ sender: Any) {
        ConfigManager.autoCopyQRs = !ConfigManager.autoCopyQRs
        updateMenuItemStatus()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        NSApp.terminate(sender)
    }
}
