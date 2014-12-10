//
//  LemonadeStand.swift
//  Lemonade Stand
//
//  Created by Kamlesh Nanda on 10/29/14.
//  Copyright (c) 2014 Kamlesh Nanda. All rights reserved.
//

import Foundation

class LemonadeStand {
    //Lemonade Ratios - more acidic, equal parts, or less acidic lemonade
    let kPricePerLemon = 2
    let kPricePerIceCube = 1
    let kNumberOfCustomers = 10
    let kAcidRangeBegin:Float = 0.0
    let kAcidRangeEnd:Float = 0.4
    let kEqualPartRangeBegin:Float = 0.4
    let kEqualPartRangeEnd:Float = 0.6
    let kDilutedRangeBegin:Float = 0.6
    let kDilutedRangeEnd:Float = 1.0
    let kAcid = "Acid"
    let kEqual = "EqualParts"
    let kDiluted = "Diluted"
    let kNonMixed = "NonMixed"
    
    var cashBalance = 0
    var lemons = 0
    var iceCubes = 0
    var lemonsInMix = 0
    var iceCubesInMix = 0
    var lemonadeMix = ""
    var lemonadeSold = 0
    var lemonadeSalesStats = [String: Int] ()
    
    init(cash:Int = 10, numberOfLemons:Int = 1, numberOfIceCubes:Int = 1) {
        self.cashBalance = cash
        self.lemons = numberOfLemons
        self.iceCubes = numberOfIceCubes
        self.lemonadeMix = kNonMixed
    }

    func sellLemonade() -> Int {
        var result = 0
        var numberOfCustomers = Int(arc4random_uniform(UInt32(self.kNumberOfCustomers)))
        var numberOfLemonadesSoldInThisRound = 0
        calculateLemonadeMix()
        if self.lemonadeMix == self.kNonMixed {
            if self.lemonsInMix == 0 && self.iceCubesInMix == 0 {
                result = 1
            } else if self.lemonsInMix == 0 && self.iceCubesInMix > 0 {
                result = 2
            } else if self.lemonsInMix > 0 && self.iceCubesInMix == 0 {
                result = 3
            }
        } else {
            for var i = 1; i < numberOfCustomers; i++ {
                var tastePreference = randomCGFloat()
                var customerPrerence = calculatePreference(preferenceValue: tastePreference)
                if self.lemonadeMix == customerPrerence {
                    self.cashBalance++
                    self.lemonadeSold++
                    numberOfLemonadesSoldInThisRound++
                    updateSalesStat(1)
                }
            }
            if numberOfLemonadesSoldInThisRound > 0 {
                println("Total lemonades sold in this round: \(numberOfLemonadesSoldInThisRound)")
                println("\(self.lemonadeMix) so far Lemonades sold \(self.lemonadeSalesStats[self.lemonadeMix])")
            } else {
                println("No match, No Revenue.")
            }
            self.resetLemonadeMix()
        }
        return result
    }
    
    func buyIceCubes(#numberOfIceCubes:Int) -> Bool {
        var result = true
        var amountNeeded = numberOfIceCubes * kPricePerIceCube
        if amountNeeded > cashBalance {
            result = false
        } else  {
            self.cashBalance -= amountNeeded
            self.iceCubes += numberOfIceCubes
        }
        return result
    }
    
    func buyLemons(#numberOfLemons:Int) -> Bool {
        var result = true
        var amountNeeded = numberOfLemons * kPricePerLemon
        if amountNeeded > cashBalance {
            result = false
        } else  {
            self.cashBalance -= amountNeeded
            self.lemons += numberOfLemons
        }
        return result
    }
    
    func returnLemons(#numberOfLemons:Int) -> Bool {
        var amountToReturn = numberOfLemons * kPricePerLemon
        var result = true
        if numberOfLemons > lemons {
            result = false
        } else {
            self.cashBalance += amountToReturn
            self.lemons -= numberOfLemons
        }
        return result
    }
    
    func returnIcecubes(#numberOfIcecubes:Int) -> Bool {
        var amountToReturn = numberOfIcecubes * kPricePerIceCube
        var result = true
        if numberOfIcecubes > iceCubes {
            result = false
        } else {
            self.cashBalance += amountToReturn
            self.iceCubes -= numberOfIcecubes
        }
        return result
    }
    
    func addToLemonadeMix(#lemonsToAdd:Int) -> Bool {
        var result = true
        if lemonsToAdd > self.lemons {
            result = false
        } else {
            self.lemons -= lemonsToAdd
            self.lemonsInMix += lemonsToAdd
            calculateLemonadeMix()
        }
        return result
    }
    
    func addToLemonadeMix(#iceCubesToAdd:Int) -> Bool {
        var result = true
        if iceCubesToAdd > self.iceCubes {
            result = false
        } else {
            self.iceCubes -= iceCubesToAdd
            self.iceCubesInMix += iceCubesToAdd
            calculateLemonadeMix()
        }
        return result
    }
    
    func removeFromLemonadeMix(#lemonsToRemove:Int) -> Bool {
        var result = true
        if lemonsToRemove > self.lemonsInMix {
            result = false
        } else {
            self.lemonsInMix -= lemonsToRemove
            self.lemons += lemonsToRemove
            calculateLemonadeMix()
        }
        return result
    }
    
    func removeFromLemonadeMix(#iceCubesToRemove:Int) -> Bool {
        var result = true
        if iceCubesToRemove > self.iceCubesInMix {
            result = false
        } else {
            self.iceCubesInMix -= iceCubesToRemove
            self.iceCubes += iceCubesToRemove
            calculateLemonadeMix()
        }
        return result
    }
    
    func randomCGFloat() -> Float {
        return Float(arc4random()) /  Float(UInt32.max)
    }
    
    func calculatePreference(#preferenceValue:Float) -> String {
        var preference = ""
        if preferenceValue >= kAcidRangeBegin && preferenceValue < kAcidRangeEnd {
            preference = kAcid
        } else if preferenceValue >= kEqualPartRangeBegin && preferenceValue < kEqualPartRangeEnd {
            preference = kEqual
        } else if preferenceValue >= kDilutedRangeBegin && preferenceValue <= kDilutedRangeEnd {
            preference = kDiluted
        }
        return preference
    }
    
    func calculateLemonadeMix() {
        if self.iceCubesInMix == 0 || self.lemonsInMix == 0 {
            self.lemonadeMix = kNonMixed
        } else {
            var lemonadeRatio:Float = Float(self.iceCubesInMix)/Float(self.lemonsInMix);
            if lemonadeRatio < 1.0 {
                self.lemonadeMix = kAcid
            } else if lemonadeRatio == 1.0 {
                self.lemonadeMix = kEqual
            } else if lemonadeRatio > 1.0 {
                self.lemonadeMix = kDiluted
            }
        }
        println("Lemonade Mix: \(self.lemonadeMix)")
    }
    
    func updateSalesStat(lemonadeSold:Int) {
        if let type = self.lemonadeSalesStats[self.lemonadeMix] {
            var updatedValue = Int(type) + lemonadeSold
            self.lemonadeSalesStats[self.lemonadeMix] = updatedValue
        } else {
            self.lemonadeSalesStats[self.lemonadeMix] = lemonadeSold
        }
    }
    
    func resetLemonadeMix() {
        self.lemonsInMix = 0
        self.iceCubesInMix = 0
        self.lemonadeMix = kNonMixed
    }
    
    func resetLemonadeStand() {
        self.cashBalance = 10
        self.lemons = 1
        self.iceCubes = 1
        self.lemonsInMix = 0
        self.iceCubesInMix = 0
        self.lemonadeMix = kNonMixed
        self.lemonadeSalesStats.removeAll(keepCapacity: true)
    }
    
    func canMakeMoreLemonade() -> Bool {
        var canMakeLemonade = true
        var totalLemons = self.lemons + self.lemonsInMix
        var totalIceCubes = self.iceCubes + self.iceCubesInMix
        if (totalLemons == 0 || totalIceCubes == 0) && self.cashBalance == 0 { //No money and no inventory
            canMakeLemonade = false
        } else if (totalLemons == 0 || totalIceCubes == 0) && self.cashBalance < (self.kPricePerLemon + self.kPricePerIceCube) { //Not enough money to buy one lemon and one icecube
            canMakeLemonade = false
        } else if totalLemons == 0 && self.cashBalance < self.kPricePerLemon {
            canMakeLemonade = false
        } else if totalIceCubes == 0 && self.cashBalance < self.kPricePerIceCube { //=> Future proofing on inflation
            canMakeLemonade = false
        }
        return canMakeLemonade
    }
}