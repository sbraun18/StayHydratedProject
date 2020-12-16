//
//  Settings.swift
//  FinalProject
//
//  Created by Rebekah Hale on 12/2/20.
//

import Foundation

struct Settings {
    static private var age: Date = Date()
    static private var weight: Double = 0.0
    static private var height: Double = 0.0
    static private var name: String = ""
    static var fileURL: URL = URL.init(fileURLWithPath: "Documents")
    
    static func setName (name: String?) {
        if let userName = name {
            self.name = userName
        }
    }
    
    static func setAge (birthday: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let _ = Date()
        
        if let birthdate = birthday {
            let date = dateFormatter.date(from: birthdate)
            if let day = date {
                self.age = day
            }
        }
    }
    
    static func setWeight (weight: String?)  {
        if let userWeight = weight, let doubleWeight = Double(userWeight) {
            self.weight = doubleWeight
        }
    }
    
    static func setHeight(height: String?)  {
        if let userHeight = height, let doubleHeight = Double(userHeight) {
            self.height = doubleHeight
        }
    }
    
    static func getName () -> String {
        return self.name
    }
    
    static func getAge () -> (String, Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let today = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: self.age, to: today)
        let age = ageComponents.year!
        
        return (String(age), self.age)
    }
    
    static func getHeight () -> (String, Double) {
        return (String(self.height) ,self.height)
    }
    
    static func getWeight () -> (String, Double) {
        return (String(self.weight), self.weight)
    }
    
}
