//
//  Utilities.swift
//  LemonadeStand
//
//  Created by Michael Renninger on 12/23/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    class func createBtn(str:String) -> UIButton {
        var btn = UIButton()
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12)
        btn.sizeToFit()
        return btn
    }
    
    class func createLabel(text:String, font:String, size:CGFloat, color:UIColor) -> UILabel {
        var lbl = UILabel()
        lbl.text = text
        lbl.textColor = color
        lbl.font = UIFont(name: font, size:size)
        lbl.sizeToFit()
        lbl.textAlignment = NSTextAlignment.Center
        return lbl
    }
    
    class func showAlertWithText(header:String = "Warning", msg:String, vc:UIViewController, action:UIAlertAction! = nil) {
        var alert = UIAlertController(title: header, message: msg, preferredStyle: .Alert)
        if action == nil {
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        } else {
            alert.addAction(action)
        }
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}
