//
//  InventoryDisplayView.swift
//  LemonadeStand
//
//  Created by Michael Renninger on 12/19/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

public class InventoryDisplayView: UIView {
    
    // Properties
    private var _value:String = ""
    private var _title:String = ""
    private var _name:String = ""
    private var _initialized = false
    
    private var _amountLbl:UILabel!
    
    public var value: String {
        get { println("InventoryDisplayView.value::get")
            return _value }
        set { println("InventoryDisplayView.value::set")
            setValue(newValue) }
    }
    
    
    
    // Overrides and Requireds
    override init(frame: CGRect) {
        println("InventoryDisplayView.init")
        super.init(frame: frame)
        self.opaque = false
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        println("InventoryDisplayView.drawRect.value: \(_value)")
        // Drawing code
        _amountLbl = Utilities.createLabel(_value, font:"AvenirNextCondensed-DemiBold", size:60, color:UIColor.darkGrayColor())
        _amountLbl.bounds.size.width = 100
        _amountLbl.frame.origin.x = 0
        self.addSubview(_amountLbl)
        
        var titleLbl:UILabel = Utilities.createLabel(_title, font: "Avenir-Heavy", size: 8, color:UIColor.lightGrayColor())
        titleLbl.center = CGPoint(x: _amountLbl.center.x, y: _amountLbl.frame.origin.y + _amountLbl.frame.height - 12)
        self.addSubview(titleLbl)
        
        //        let dot = UIView()
        //        dot.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
        //        dot.backgroundColor = UIColor.redColor()
        //        addSubview(dot)
    }
    
    
    
    // Methods
    func setValue(value:String) {
        println("InventoryDisplayView.setValue: \(value)")
        _amountLbl?.text = value
    }
    
    func initValues(value:String, title:String, name:String) {
        if (_initialized == false ) {
            println("InventoryDisplayView.initValues: \(value), \(title), \(name)")
            _value = value
            _title = title
            _name = name
        }
    }
}
