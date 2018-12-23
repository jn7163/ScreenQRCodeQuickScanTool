//
//  QRCodeGeneratorViewController.swift
//  ScreenQRCodeQuickScanTool
//
//  Created by CYC on 2018/11/21.
//  Copyright © 2018 west2. All rights reserved.
//

import Cocoa

class QRCodeGeneratorViewController: NSViewController {
    
    @IBOutlet weak var contentTextField: NSTextView!
    @IBOutlet weak var qrImageView: NSImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextField.delegate = self
        
        qrImageView.wantsLayer = true
        qrImageView.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    func updateQR() {
        qrImageView.image = generateQRCode(from: self.contentTextField.string,width: qrImageView.frame.size.width)

    }
    
    func getImageData()->Data? {
        return nil
    }
    
    @IBAction func actionCopy(_ sender: Any) {
        guard let image = qrImageView.image else {return}
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([image])
    }
    
    
    @IBAction func actionSave(_ sender: Any) {
        let panel = NSSavePanel()
        panel.title = "Save file"
        panel.showsResizeIndicator = true
        panel.canCreateDirectories = true
        panel.showsHiddenFiles = true
        panel.allowedFileTypes = ["png"]
        if panel.runModal() == .OK {
            guard let res = panel.url else {return}
            qrImageView.image?.writePNG(toURL: res)
        }
    }
}

extension QRCodeGeneratorViewController:NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        updateQR()
    }
    
}

extension QRCodeGeneratorViewController {
    func generateQRCode(from string: String,width:CGFloat) -> NSImage? {
        guard string.count > 0 else {return nil}
        let data = string.data(using: .utf8, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let qrcodeImage = filter.outputImage else {return nil}
        
        let rep = NSCIImageRep(ciImage: qrcodeImage)
        let tinyImage = NSImage()
        tinyImage.addRepresentation(rep)
        let qrImage = NSImage(size: CGSize(width: width, height: width))
        qrImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .none
        tinyImage.draw(in: NSRect(x: 0, y: 0, width: width, height: width))
        qrImage.unlockFocus()
        
        return qrImage
    }
}


extension NSImage {
    public func writePNG(toURL url: URL) {
        
        guard let data = tiffRepresentation,
            let rep = NSBitmapImageRep(data: data),
            let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
                
                Swift.print("\(self.self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
                return
        }
        
        do {
            try imgData.write(to: url)
        }catch let error {
            Swift.print("\(self.self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}
