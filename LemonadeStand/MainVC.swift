//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Michael Renninger on 11/26/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // Constants
    let NUM_CONTAINERS:Int = 5
    let MARGIN_VIEW:CGFloat = 0.0
    let MARGIN_CONTAINER:CGFloat = 10.0
    
    let MEYER_LEMON:UIColor = UIColor(red: 0.99, green: 0.79, blue: 0.0, alpha: 1.0)
    
    let HALF:CGFloat = 1.0/2.0
    let THIRD:CGFloat = 1.0/3.0
    let FOURTH:CGFloat = 1.0/4.0
    let FIFTH:CGFloat = 1.0/5.0
    let SIXTH:CGFloat = 1.0/6.0
    let EIGHTH:CGFloat = 1.0/8.0
    let TENTH:CGFloat = 1.0/10.0
    let TWELFTH:CGFloat = 1.0/12.0
    
    let COST_LEMON:Int = 2
    let COST_ICE:Int = 1
    

    // Properties
    var containers:[UIView] = []
    var containerHeights:[CGFloat] = [0.1, 0.15, 0.2, 0.2, 0.35]
    var containerColors:[UIColor] = [UIColor(red: 0.99, green: 0.79, blue: 0.0, alpha: 1.0),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.lightGrayColor()]
    var containerLabels = [
        (text:"Lemonade Stand", size:18.0, font:"Avenir-Heavy", position:CGPoint(x: 10, y: 10)),
        (text:"Your Inventory:", size:12.0, font:"Avenir-Heavy", position:CGPoint(x: 10, y: 10)),
        (text:"Buy Supplies:", size:12.0, font:"Avenir-Heavy", position:CGPoint(x: 10, y: 10)),
        (text:"Today's Mix:", size:12.0, font:"Avenir-Heavy", position:CGPoint(x: 10, y: 10)),
        (text:"The weather today is", size:15, font:"Avenir-Heavy", position:CGPoint(x: 10, y: 10))
    ]
    var weather:[String] = ["Cold", "Mild", "Warm"]
    var customerPrefs:[CGFloat] = []
    var lemonadeQuality:String = ""
    
    // Inventory
    var moneyInventoryDisplay:InventoryDisplayView!
    var moneyInventoryAmount:Int = 10 { didSet { moneyInventoryDisplay.value = "$\(moneyInventoryAmount)" } }
    
    var lemonsInventoryDisplay:InventoryDisplayView!
    var lemonsInventoryAmount:Int = 1 { didSet { lemonsInventoryDisplay.value = "\(lemonsInventoryAmount)" } }
    
    var iceInventoryDisplay:InventoryDisplayView!
    var iceInventoryAmount:Int = 1 { didSet { iceInventoryDisplay.value = "\(iceInventoryAmount)" } }
    
    // Supplies
    var lemonsSupplyStepper:CustomStepperView!
    var lemonsSupplyAmount: Int = 0 { didSet { lemonsSupplyStepper.update(lemonsSupplyAmount) } }
    var iceSupplyStepper:CustomStepperView!
    var iceSupplyAmount: Int = 0 { didSet { iceSupplyStepper.update(iceSupplyAmount) } }
    
    // Mix
    var lemonsMixStepper:CustomStepperView!
    var lemonsMixAmount:Int = 0 { didSet { lemonsMixStepper.update(lemonsMixAmount) } }
    var iceMixStepper:CustomStepperView!
    var iceMixAmount:Int = 0 { didSet { iceMixStepper.update(iceMixAmount) } }
    
    // Weather
    var weatherIconView:UIImageView!
    
    // Results
    var resultsLbl:UILabel!
    var resultsTV:UITextView!


    
    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Button Actions
    func onStartDayBtnPressed(btn:UIButton) {
        println("ƒ onStartDayBtnPressed")
        if lemonsMixAmount == 0 && iceMixAmount == 0 {
            let alertAction:UIAlertAction = UIAlertAction(title: "My Bad", style: .Default, handler: nil)
            Utilities.showAlertWithText(header: "Hold on a hot minute!", msg: "You need to actually add lemons and ice to make lemonade.", vc: self, action: alertAction)
        } else if lemonsMixAmount == 0 && iceMixAmount > 0 {
            let alertAction:UIAlertAction = UIAlertAction(title: "Oops!", style: .Default, handler: nil)
            Utilities.showAlertWithText(header: "WTF?!?!", msg: "Are you trying to pass off ice water as lemonade?  Try again.", vc: self, action: alertAction)
        } else if lemonsMixAmount > 0 && iceMixAmount == 0 {
            let alertAction:UIAlertAction = UIAlertAction(title: "Doh!", style: .Default, handler: nil)
            Utilities.showAlertWithText(header: "ICK!", msg: "No one wants to buy pure lemon juice...  Try again.", vc: self, action: alertAction)
        } else {
            updateResultsDisplay("")
            mixLemonade()
            generateCustomers()
            reset();
            checkGameOver()
        }
    }

    // Methods
    func setupUI () {
        var thickness:CGFloat = 0.5
        for var i = 0; i < NUM_CONTAINERS; i++ {
            var tContainer = UIView()
            // create the containers according to the heights in the containerHeights array
            tContainer.frame = CGRect(
                x: self.view.bounds.origin.x + MARGIN_VIEW,
                y: (i == 0) ? self.view.bounds.origin.y : containers[i-1].frame.origin.y + containers[i-1].frame.height,
                width: self.view.bounds.width - (MARGIN_VIEW * 2),
                height: self.view.bounds.height * containerHeights[i])
            tContainer.backgroundColor = containerColors[i]
            
            var titleLbl = UILabel()
            titleLbl.text = containerLabels[i].text
            titleLbl.textColor = UIColor.darkGrayColor()
            titleLbl.textAlignment = NSTextAlignment.Center
            titleLbl.font = UIFont(name: containerLabels[i].font, size:CGFloat(containerLabels[i].size))
            titleLbl.sizeToFit()
            titleLbl.center = (i == 0) ? CGPoint(x: tContainer.center.x, y: tContainer.frame.height * THIRD * 2) : CGPoint(x: tContainer.center.x, y: titleLbl.frame.height * HALF + 5)
            tContainer.addSubview(titleLbl)
            
            if i == (NUM_CONTAINERS - 1) {
                var btn = Utilities.createBtn("Let's Sell Some Lemonade!")
                btn.backgroundColor = MEYER_LEMON
                btn.bounds.size.width = tContainer.bounds.size.width - (MARGIN_CONTAINER * 2)
                btn.center = CGPoint(x:tContainer.frame.width * HALF, y:tContainer.frame.height - btn.bounds.size.height)
                btn.addTarget(self, action: "onStartDayBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                tContainer.addSubview(btn)
            }
            
            var line = UIView(frame: CGRect(x:0, y:tContainer.frame.height - thickness, width:tContainer.bounds.size.width, height:thickness))
            line.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            tContainer.addSubview(line)
            
            containers.append(tContainer)
            self.view.addSubview(tContainer)
            setupContainer(i)

        }
        
    }
    
    func setupContainer(num:Int) {
        println("ƒ setupContainer: \(num)")
        switch num {
        case 0:
            println("\tcase 0: header - nothing else to set up")
        case 1:
            moneyInventoryDisplay = InventoryDisplayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            moneyInventoryDisplay.initValues("$\(moneyInventoryAmount)", title: "Money", name: "moneyInventory")
            moneyInventoryDisplay.center = CGPoint(x: containers[num].frame.width * SIXTH, y: containers[num].bounds.height / 2 + 19)
            containers[num].addSubview(moneyInventoryDisplay)
            
            lemonsInventoryDisplay = InventoryDisplayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            lemonsInventoryDisplay.initValues("\(lemonsInventoryAmount)", title: "Lemons", name: "lemonsInventory")
            lemonsInventoryDisplay.center = CGPoint(x: containers[num].frame.width * SIXTH * 3, y: containers[num].bounds.height / 2 + 19)
            containers[num].addSubview(lemonsInventoryDisplay)
            
            iceInventoryDisplay = InventoryDisplayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            iceInventoryDisplay.initValues("\(iceInventoryAmount)", title: "Ice Cubes", name: "iceInventory")
            iceInventoryDisplay.center = CGPoint(x: containers[num].frame.width * SIXTH * 5, y: containers[num].bounds.height / 2 + 19)
            containers[num].addSubview(iceInventoryDisplay)

        case 2:
            lemonsSupplyStepper = CustomStepperView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
            lemonsSupplyStepper.initValues(lemonsSupplyAmount, title: "Lemons - $2", name: "lemonSupply")
            lemonsSupplyStepper.center = CGPoint(x: containers[num].frame.width * FOURTH, y: containers[num].bounds.height / 2)
            lemonsSupplyStepper.delegate = self
            containers[num].addSubview(lemonsSupplyStepper)
            
            
            iceSupplyStepper = CustomStepperView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
            iceSupplyStepper.initValues(iceSupplyAmount, title: "Ice Cubes - $1", name: "iceSupply")
            iceSupplyStepper.center = CGPoint(x: containers[num].frame.width * FOURTH * 3, y: containers[num].bounds.height / 2)
            iceSupplyStepper.delegate = self
            containers[num].addSubview(iceSupplyStepper)
            
        case 3:
            lemonsMixStepper = CustomStepperView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
            lemonsMixStepper.initValues(lemonsMixAmount, title: "Lemons", name: "lemonMix")
            lemonsMixStepper.center = CGPoint(x: containers[num].frame.width * FOURTH, y: containers[num].bounds.height / 2)
            lemonsMixStepper.delegate = self
            containers[num].addSubview(lemonsMixStepper)
            
            iceMixStepper = CustomStepperView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
            iceMixStepper.initValues(iceMixAmount, title: "Ice Cubes", name: "iceMix")
            iceMixStepper.center = CGPoint(x: containers[num].frame.width * FOURTH * 3, y: containers[num].bounds.height / 2)
            iceMixStepper.delegate = self
            containers[num].addSubview(iceMixStepper)
            
        case 4:
            weatherIconView = UIImageView(frame: CGRect(x:containers[num].center.x, y:25, width:20, height:20))
            containers[num].addSubview(weatherIconView)
            
            resultsTV = UITextView()
            resultsTV.editable = false
            resultsTV.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 12)
            resultsTV.textColor = UIColor.whiteColor()
            resultsTV.frame.origin.x = 10
            resultsTV.frame.origin.y = 50
            resultsTV.frame.size.width = containers[num].frame.width - 20
            resultsTV.frame.size.height = containers[num].frame.height - 100
            resultsTV.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            containers[num].addSubview(resultsTV)
        default:
            println("default")
        }
    }
    
    func buyLemon(bool:Bool = true) {
        if bool {
            if haveEnoughMoney(COST_LEMON) {
                moneyInventoryAmount -= COST_LEMON
                lemonsInventoryAmount += 1
                lemonsSupplyAmount += 1
            }
            else {
                Utilities.showAlertWithText(header: "Out of money!", msg: "Looks like you need to retun some items.", vc: self)
            }
        }
        else {
            if lemonsSupplyAmount > 0 {
                moneyInventoryAmount += COST_LEMON
                lemonsInventoryAmount -= 1
                lemonsSupplyAmount -= 1
            }
        }
    }
    
    func buyIce(bool:Bool = true) {
        if bool {
            if haveEnoughMoney(COST_ICE) {
                moneyInventoryAmount -= COST_ICE
                iceInventoryAmount += 1
                iceSupplyAmount += 1
            } else {
                Utilities.showAlertWithText(header: "Out of money!", msg: "Looks like you need to return some items.", vc: self)
            }
        }
        else {
            if iceSupplyAmount > 0 {
                moneyInventoryAmount += COST_ICE
                iceInventoryAmount -= 1
                iceSupplyAmount -= 1
            }
        }
    }
    
    func addLemon(bool:Bool = true) {
        if bool {
            if lemonsInventoryAmount > 0 {
                lemonsInventoryAmount -= 1
                lemonsMixAmount += 1
            } else {
                Utilities.showAlertWithText(header: "Out of lemons!", msg: "Looks like you need more supplies.", vc: self)
            }
        }
        else {
            if lemonsMixAmount > 0 {
                lemonsInventoryAmount += 1
                lemonsMixAmount -= 1
            }
        }
    }
    
    func addIce(bool:Bool = true) {
        if bool {
            if iceInventoryAmount > 0 {
                iceInventoryAmount -= 1
                iceMixAmount += 1
            } else {
                Utilities.showAlertWithText(header: "Out of ice!", msg: "Looks like you need more supples.", vc: self)
            }
        }
        else {
            if iceMixAmount > 0 {
                iceInventoryAmount += 1
                iceMixAmount -= 1
            }
        }
    }
    
    func mixLemonade() {
        let ratio = CGFloat(CGFloat(lemonsMixAmount)/CGFloat(iceMixAmount))
        println(ratio)
        lemonadeQuality = getLemonadeMixString(ratio)
        var info:String = "lemonade ratio: \(ratio) | quality: " + lemonadeQuality
        updateResultsDisplay(info)
    }
    
    func generateCustomers() {
        customerPrefs.removeAll(keepCapacity: false)
        
        var numCustomers = 1 + Int(arc4random_uniform(UInt32(10)))
        
        var curWeather = checkWeather()
        if curWeather == "Cold" {
            numCustomers -= 3
            if numCustomers < 0 { numCustomers = 0 }
        }
        if curWeather == "Warm" {
            numCustomers += 4
        }
        
        var info:String = "The weather is \(curWeather) and you have \(numCustomers) customers"
        updateResultsDisplay(info)

        if numCustomers > 0 {
            for var i = 0; i < numCustomers; i++ {
                var randNum = CGFloat(arc4random())/CGFloat(UInt32.max)
                customerPrefs.append(CGFloat(arc4random())/CGFloat(UInt32.max))
                var quality = getCustomerPreferenceString(customerPrefs[i])
                
                var info:String = "Customer #\(i+1) -  ratio: \(customerPrefs[i]) |  quality: " + quality
                
                if quality == lemonadeQuality {
                    //updateMoneyInventory(moneyInventoryAmount + 1)
                    moneyInventoryAmount += 1
                    println("\(info) - Paid!")
                    updateResultsDisplay("\(info) - Paid!")

                } else {
                    println("\(info) - No Match :(")
                    updateResultsDisplay("\(info) - No Match :(")
                }
            }
        }
    }
    
    func reset() {
        println("ƒ reset")
        lemonsSupplyAmount = 0
        iceSupplyAmount = 0
        lemonsMixAmount = 0
        iceMixAmount = 0
    }
    
    func restart() {
        println("ƒ restart")
        updateResultsDisplay("")
        
        weatherIconView.image = nil
        
        moneyInventoryAmount = 10
        lemonsInventoryAmount = 1
        iceInventoryAmount = 1
        
        reset()
    }
    
    func checkGameOver() {
        let alertAction:UIAlertAction = UIAlertAction(title: "Restart", style: .Default) { action -> Void in self.restart() }
        var msg:String = ""
        var gameOver:Bool = false
        
        if moneyInventoryAmount == 0 && (lemonsInventoryAmount == 0 || iceInventoryAmount == 0) {
            msg = "Sorry buddy. You're out of money!"
            gameOver = true
        }
        
        if moneyInventoryAmount == 1 && lemonsInventoryAmount == 0 {
            msg = "Sorry buddy. You don't have enough money to buy supplies."
            gameOver = true
        }
        
        if moneyInventoryAmount == 2 && lemonsInventoryAmount == 0 && iceInventoryAmount == 0 {
            msg = "Sorry buddy. You don't have enough money to buy supplies."
            gameOver = true
        }
        
        if gameOver { Utilities.showAlertWithText(header: "GAME OVER!", msg: msg, vc: self, action:alertAction) }
    }
    
    func updateResultsDisplay(txt:String) {
        resultsTV.text = (txt == "") ? nil : "\(resultsTV.text!)\r\(txt)"
        println(txt)
    }
    
    
    
    // Helpers
    func haveEnoughMoney(amt:Int) -> Bool {
        return ((moneyInventoryAmount - amt) >= 0)
    }
    
    func checkWeather() -> String{
        var randNum = Int(arc4random_uniform(UInt32(weather.count)))
        weatherIconView.image = UIImage(named:weather[randNum])
        return weather[randNum]
    }
    
    func getCustomerPreferenceString(num:CGFloat) -> String {
        var str = ""
        switch num {
        case 0.0...0.4:
            str = "acidic"
        case 0.4...0.6:
            str = "equal"
        default:
            str = "diluted"
        }
        return str
    }
    
    func getLemonadeMixString(num:CGFloat) -> String {
        var str = ""
        if num > 1 {
            str = "acidic"
        } else if num == 1 {
            str = "equal"
        } else {
            str = "diluted"
        }
        return str
    }
}

extension MainVC: CustomStepperViewDelegate {
    func stepperChanged(stepper:CustomStepperView, didIncrease:Bool) {
        switch stepper.name {
        case "lemonSupply":
            buyLemon(bool: didIncrease)
            
        case "iceSupply":
            buyIce(bool: didIncrease)
            
        case "lemonMix":
            addLemon(bool: didIncrease)
            
        case "iceMix":
            addIce(bool: didIncrease)
            
        default:
            println("OOPS!")
        }
    }
}
