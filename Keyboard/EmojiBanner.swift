//
//  EmojiBanner.swift
//  EmojiSearchKeyboard
//
//  Created by Jesse Hu on 1/19/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import UIKit

/*
This is the demo banner. The banner is needed so that the top row popups have somewhere to go. Might as well fill it
with something (or leave it blank if you like.)
*/

class EmojiBanner: ExtraView {

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var emojiButton: UIButton = UIButton()
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        emojiButton.addTarget(self, action: "pressed:", forControlEvents: .TouchDown)
        emojiButton.addTarget(self, action: "released:", forControlEvents: .TouchUpInside)
        
        self.addSubview(self.emojiButton)
        
        //        self.catSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled)
        //        self.catSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        //        self.catSwitch.addTarget(self, action: Selector("respondToSwitch"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.updateAppearance()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.emojiButton.center = self.center
        
        //        self.catSwitch.center = self.center
        
        //        self.catLabel.frame.origin = CGPointMake(self.catSwitch.frame.origin.x + self.catSwitch.frame.width + 8, self.catLabel.frame.origin.y)
    }
    
    //    func respondToSwitch() {
    //        NSUserDefaults.standardUserDefaults().setBool(self.catSwitch.on, forKey: kCatTypeEnabled)
    //        self.updateAppearance()
    //    }
    
    func pressed(sender: UIButton!) {
        self.emojiButton.backgroundColor = UIColor(red: (112/255.0), green: (112/255.0), blue: (112/255.0), alpha: 0.8)
    }
    
    func released(sender: UIButton!) {
        self.emojiButton.backgroundColor = UIColor(red: (65/255.0), green: (65/255.0), blue: (65/255.0), alpha: 0.8)
    }
    
    func updateAppearance() {
        self.emojiButton.backgroundColor = UIColor(red: (65/255.0), green: (65/255.0), blue: (65/255.0), alpha: 0.8)
        self.emojiButton.setTitle("hi", forState: UIControlState.Normal)
        self.emojiButton.setTitle(toString(self.frame.width), forState: UIControlState.Highlighted)
        
        self.emojiButton.sizeToFit()
        
        self.emojiButton.frame = CGRectMake(self.emojiButton.frame.minX,
            self.emojiButton.frame.minY,
            screenSize.width,
            self.emojiButton.frame.height)
    }
}
