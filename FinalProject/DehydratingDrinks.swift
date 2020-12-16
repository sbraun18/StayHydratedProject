//
//  CaffeinatedDrinks.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

//coffee
//- decaf or not
//- ammount of shots
//- ammount of liquid
//energy drink
//- ammount
//soda
//- caffinated
//- diet - regular - sugar free
//- ammount
//tea
//- decaf or not
//- ammount of shots
//- ammount of liquid

import Foundation

class DehydratingDrinks: Drinks {
    var caffeinated: Bool = false
    var caffeinePercentage: Double
    
    init (caffeinated: Bool, caffeinePercentage: Double, type: String, amount: Double, date: Date, time: Date) {
        self.caffeinated = caffeinated
        self.caffeinePercentage = caffeinePercentage
        super.init(type: type, amount: amount, date: date, time: date)
    }
    
    func decreaseWaterLevel (currentWaterLevel: Double, decreasedWaterAmount: Double) {
        
    }
    
}
