//
//  NSUserNotificationCenter+Extension.swift
//  ClashX
//
//  Created by CYC on 2018/8/6.
//  Copyright © 2018年 yichengchen. All rights reserved.
//

import Cocoa

extension NSUserNotificationCenter {
    func post(title:String,info:String,identifier:String? = nil) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = info
        if identifier != nil {
            notification.userInfo = ["identifier":identifier!]
        }
        self.delegate = UserNotificationCenterDelegate.shared
        self.deliver(notification)
    }
    
    func postQRFound(content:String) {
        let title = ConfigManager.autoCopyQRs ? "发现二维码 已复制" : "发现二维码 点击复制"
        post(title: title, info:content ,identifier: "postQRFound")
    }
    
    func postCopySuccess(content:String) {
        post(title: "复制成功", info:content)
    }
}

class UserNotificationCenterDelegate:NSObject,NSUserNotificationCenterDelegate {
    static let shared = UserNotificationCenterDelegate()
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if (notification.userInfo?["identifier"] as? String) == "postQRFound" {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(notification.informativeText ?? "", forType: .string)
            NSUserNotificationCenter.default.postCopySuccess(content: notification.informativeText ?? "")
        }
        center.removeDeliveredNotification(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
