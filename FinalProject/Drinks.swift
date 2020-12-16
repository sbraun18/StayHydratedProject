//
//  Drinks.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

// DRINKS:
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

class Drinks {
    var type: String
    var amount: Double
    var date: Date
    var time: Date
    
    init (type: String, amount: Double, date: Date, time: Date) {
        self.type = type
        self.amount = amount
        self.date = date
        self.time = time
    }
    /*
    if HKHealthStore.isHealthDataAvailable() {
        // Add code to use HealthKit here.
    }
 */
}
