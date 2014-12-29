//
//  CustomStepperView.swift
//  LemonadeStand
//
//  Created by Michael Renninger on 12/18/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

@objc protocol CustomStepperViewDelegate {
    optional func stepperChanged(view:CustomStepperView, didIncrease:Bool)
    
    optional func stepperIncreased(view:CustomStepperView)

    optional func stepperDecreased(view:CustomStepperView)
}

public class CustomStepperView: UIView {

    private var _value:Int = 0
    private var _title:String = "Stepper Title"
    private var _name:String = ""
    
    var delegate:CustomStepperViewDelegate?
    
    private var _amountLbl:UILabel!
    
    public var name: String {
        get { return _name }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initValues(value:Int, title:String, name:String) {
        _value = value
        _title = title
        _name = name
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        println("ƒ CustomStepperView.drawRect")
        
        _amountLbl = Utilities.createLabel("\(_value)", font:"AvenirNextCondensed-DemiBold", size:60, color:UIColor.darkGrayColor())
        _amountLbl.bounds.size.width = 75
        _amountLbl.frame.origin.x = 20
        self.addSubview(_amountLbl)
        
        var plusBtn:UIButton = createPlusMinusBtn("+", label:_amountLbl, offset:-20, action:"onValueIncrease:")
        self.addSubview(plusBtn)
        self.addSubview(createPlusMinusBtn("-", label:_amountLbl, offset:20, action:"onValueDecrease:"))
        
        var titleLbl:UILabel = Utilities.createLabel(_title, font: "Avenir-Heavy", size: 8, color:UIColor.lightGrayColor())
        titleLbl.center = CGPoint(x: _amountLbl.center.x, y: plusBtn.frame.origin.y + plusBtn.frame.height + 15)
        self.addSubview(titleLbl)
        
//        let dot = UIView()
//        dot.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
//        dot.backgroundColor = UIColor.redColor()
//        addSubview(dot)
    }
    
    func createPlusMinusBtn(str:String, label:UILabel, offset:CGFloat, action:Selector) -> UIButton {
        var btn = UIButton()
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12)
        btn.backgroundColor = UIColor(red: 0.99, green: 0.79, blue: 0.0, alpha: 1.0)
        btn.bounds.size.width = CGFloat(20.0)
        btn.bounds.size.height = CGFloat(20.0)
        btn.center = CGPoint(x:label.center.x + offset, y:label.frame.origin.y + label.frame.height)
        btn.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
        
    func update(amt:Int) {
        println("\(_name).update: \(amt)")
        _amountLbl?.text = "\(amt)"
    }
    
    func onValueIncrease(btn:UIButton) {
        println("ƒ CustomStepperView.onValueIncrease")
        //delegate?.stepperIncreased!(self)
        delegate?.stepperChanged!(self, didIncrease: true)
    }
    
    func onValueDecrease(btn:UIButton) {
        println("ƒ CustomStepperView.onValueDecrease")
        //delegate?.stepperDecreased!(self)
        delegate?.stepperChanged!(self, didIncrease: false)
    }

}
