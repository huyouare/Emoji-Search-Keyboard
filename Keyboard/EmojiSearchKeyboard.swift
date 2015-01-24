//
//  EmojiSearchKeyboard.swift
//
//  Created by Jesse Hu on 1/18/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import UIKit

/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/

let kEmojisEnabled = "kEmojisEnabled"

class EmojiSearchKeyboard: KeyboardViewController, EmojiBannerProtocol {
    
    let takeDebugScreenshot: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kEmojisEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentWord: String = ""
    
    override func keyPressed(key: Key) {
        
        if let textDocumentProxy = self.textDocumentProxy as? UITextDocumentProxy {
            let keyOutput = key.outputForCase(self.shiftState.uppercase())
            
//            if !NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled) {
//                textDocumentProxy.insertText(keyOutput)
//                return
//            }
            
            
//            if key.type == .Character || key.type == .SpecialCharacter {
//                let context = textDocumentProxy.documentContextBeforeInput
//                
//                //                EmojiBanner.updateButtons(context)
//                
//                if context != nil {
//                    if countElements(context) < 2 {
//                        textDocumentProxy.insertText(keyOutput)
//                        return
//                    }
//                    
//                    var index = context!.endIndex
//                    
//                    index = index.predecessor()
//                    if context[index] != " " {
//                        textDocumentProxy.insertText(keyOutput)
//                        return
//                    }
//                    // previous character was a space
//                    
//                    index = index.predecessor()
//                    if context[index] == " " {
//                        textDocumentProxy.insertText(keyOutput)
//                        return
//                    }
//                    // character before previous was not a space
//                    
//                    // textDocumentProxy.insertText("\(randomCat())")
//                    // textDocumentProxy.insertText(" ")
//                    textDocumentProxy.insertText(keyOutput)
//                    return
//                }
//                else {
//                    textDocumentProxy.insertText(keyOutput)
//                    return
//                }
//            }
            
            if key.type == .Character || key.type == .SpecialCharacter {
                let context = textDocumentProxy.documentContextBeforeInput
                currentWord = currentWord + keyOutput
                EmojiBanner.updateButtons(currentWord)
                textDocumentProxy.insertText(keyOutput)
            }
                // TODO: Implement deletion via context 'x' (whole sentence deletion)
            else if key.type == .Backspace {
                if !currentWord.isEmpty {
                    currentWord = currentWord.substringToIndex(currentWord.endIndex.predecessor())
                }
                EmojiBanner.updateButtons(currentWord)
            }
            else {
                textDocumentProxy.insertText(keyOutput)
                currentWord = ""
                EmojiBanner.updateButtons(currentWord)
            }
        }
    }
    
    func emojiButtonPressed(emojiString: String) {
        var count: Int = countElements(currentWord)
        
        if let textDocumentProxy = self.textDocumentProxy as? UITextDocumentProxy {
            for i in 0..<count {
                textDocumentProxy.deleteBackward()
            }
            textDocumentProxy.insertText(emojiString)
        }
        currentWord = ""
    }
    
    override func setupKeys() {
        super.setupKeys()
        
        if takeDebugScreenshot {
            if self.layout == nil {
                return
            }
            
            for page in keyboard.pages {
                for rowKeys in page.rows {
                    for key in rowKeys {
                        if let keyView = self.layout!.viewForKey(key) {
                            keyView.addTarget(self, action: "takeScreenshotDelay", forControlEvents: .TouchDown)
                        }
                    }
                }
            }
        }
    }
    
    override func createBanner() -> ExtraView? {
        EmojiBanner.setDelegate(self)
        return EmojiBanner(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
    }
    
    func takeScreenshotDelay() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("takeScreenshot"), userInfo: nil, repeats: false)
    }
    
    func takeScreenshot() {
        if !CGRectIsEmpty(self.view.bounds) {
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
            
            let oldViewColor = self.view.backgroundColor
            self.view.backgroundColor = UIColor(hue: (216/360.0), saturation: 0.05, brightness: 0.86, alpha: 1)
            
            var rect = self.view.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            var context = UIGraphicsGetCurrentContext()
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            var capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let name = (self.interfaceOrientation.isPortrait ? "Screenshot-Portrait" : "Screenshot-Landscape")
            var imagePath = "/Users/jessehu/Documents/screenshots/tasty-imitation-keyboard/\(name).png"
            UIImagePNGRepresentation(capturedImage).writeToFile(imagePath, atomically: true)
            
            self.view.backgroundColor = oldViewColor
        }
    }
}