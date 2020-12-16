//
//  AlcoholicDrinks.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

//alcohol
//- wine
//- - ammount
//- beer
//- - ammount
//- cockatails = 40%
//- - ammount
//- other
// - - ammount
import Foundation

class AlcoholicDrinks: Drinks {
    var subtype: String
    var alcPercent: Double
    
    init (subtype: String, alcPercent: Double, type: String, amount: Double, date: Date, time: Date) {
        self.subtype = subtype
        self.alcPercent = alcPercent
        super.init(type: type, amount: amount, date: date, time: time)
    }
}
