//
//  HydratingDrinks.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

/*
 water
 - ammount
 
 juice
 - ammount

 milk
 - ammount
 sport drink
 - ammount
 */

import Foundation

class HydratingDrinks: Drinks {
    var hydratePercent: Double
    
    init (hydratePercent: Double, type: String, amount: Double, date: Date, time: Date) {
        self.hydratePercent = hydratePercent
        super.init(type: type, amount: amount, date: date, time: time)
    }
    
    func increaseWaterLevel () {
        
    }
}
