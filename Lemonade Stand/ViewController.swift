//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by Kamlesh Nanda on 10/29/14.
//  Copyright (c) 2014 Kamlesh Nanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lemonBalanceLabel: UILabel!
    @IBOutlet weak var iceCubeBalanceLabel: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var lemonsInMixLabel: UILabel!
    @IBOutlet weak var iceCubesInMixLabel: UILabel!
    
    
    var lemonadeStand: LemonadeStand = LemonadeStand()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        buyLemonsButton.setImage(UIImage(named: "LemonsWithTag"), forState: UIControlState.Normal)
//        lemonsPurchased
        updateLemonadeStandState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buyLemonPressed(sender: UIButton) {
        var canBuy = lemonadeStand.buyLemons(numberOfLemons: 1)
        if !canBuy {
            self.showAlertWithText(header: "Warning", message: "Cannot buy Lemons, not enough Cash.")
        } else {
            updateLemonadeStandState()
        }
    }

    @IBAction func returnLemonPressed(sender: UIButton) {
        var canReturn = lemonadeStand.returnLemons(numberOfLemons: 1)
        if !canReturn {
            self.showAlertWithText(header: "Warning", message: "Nothing to return.")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func buyIceCubePressed(sender: UIButton) {
        var canBuy = lemonadeStand.buyIceCubes(numberOfIceCubes: 1)
        if !canBuy {
            self.showAlertWithText(header: "Warning", message: "Cannot buy Ice cubes, not enough Cash.")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func returnIcecubePressed(sender: UIButton) {
        var canReturn = lemonadeStand.returnIcecubes(numberOfIcecubes: 1)
        if !canReturn {
            self.showAlertWithText(header: "Warning", message: "Nothing to return.")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func addLemonToLemonadePressed(sender: UIButton) {
        var canSupportMix = lemonadeStand.addToLemonadeMix(lemonsToAdd:1)
        if(!canSupportMix) {
            showAlertWithText(message: "Not enough lemons to add to mix")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func removeLemonFromLemonadePressed(sender: UIButton) {
        var canSupportMix = lemonadeStand.removeFromLemonadeMix(lemonsToRemove:1)
        if(!canSupportMix) {
            showAlertWithText(message: "No more lemons in the mix to return")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func addIceCubesToLemonadePressed(sender: UIButton) {
        var canSupportMix = lemonadeStand.addToLemonadeMix(iceCubesToAdd: 1)
        if(!canSupportMix) {
            showAlertWithText(message: "Not enough ice cubes to add to mix")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func removeIceCubeFromLemonadePressed(sender: UIButton) {
        var canSupportMix = lemonadeStand.removeFromLemonadeMix(iceCubesToRemove: 1)
        if(!canSupportMix) {
            showAlertWithText(message: "No more ice cubes in the mix to return")
        } else {
            updateLemonadeStandState()
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        var sellCode = self.lemonadeStand.sellLemonade()
        if sellCode > 0 {
            switch sellCode {
            case 2:
                    self.showAlertWithText(message: "Lemonade without Lemons, really! 😱")
            case 3:
                    self.showAlertWithText(message: "Ain't that a hot Lemonade ! 😓")
            default:
                    self.showAlertWithText(message: "Sleeping on the job, not good!\nMix it a little, will ya! 😡")
            }
        } else {
            self.updateLemonadeStandState()
        }
        if !self.lemonadeStand.canMakeMoreLemonade() {
            self.showAlertWithText(header: "Tough Luck", message: "Lemonade business is hard.\nHere is what you earned so far: $\(self.lemonadeStand.lemonadeSold)\nInventory left: \(self.lemonadeStand.lemons) lemon(s), \(self.lemonadeStand.iceCubes) icecube(s)")
            self.lemonadeStand.resetLemonadeStand()
            self.updateLemonadeStandState()
        }
    }

    func showAlertWithText(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLemonadeStandState() {
        currentBalance.text = "$\(self.lemonadeStand.cashBalance)"
        lemonBalanceLabel.text = "\(self.lemonadeStand.lemons) Lemons"
        iceCubeBalanceLabel.text = "\(self.lemonadeStand.iceCubes) IceCubes"
        lemonsInMixLabel.text = "\(self.lemonadeStand.lemonsInMix)"
        iceCubesInMixLabel.text = "\(self.lemonadeStand.iceCubesInMix)"
    }
}

