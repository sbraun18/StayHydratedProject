//
//  HealthStore.swift
//  FinalProject
//
//  Created by Rebekah Hale on 12/2/20.
//

import Foundation
import HealthKit

@available(iOS 13.0, *)
class HealthStore {
    var healthStore: HKHealthStore?
    
    init () {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
    
    func requestWaterAuthorization (completion: @escaping (Bool) -> Void) {
        let waterIntake = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        
        healthStore.requestAuthorization(toShare: [waterIntake], read: [waterIntake]) { (success, error) in
            completion(success)
        }
    }
    
    func requestCaffeineAuthorization (completion: @escaping (Bool) -> Void) {
        let caffineIntake = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        
        healthStore.requestAuthorization(toShare: [caffineIntake], read: [caffineIntake]) { (success, error) in
            completion(success)
        }
        
    }
    
    func addWater (ounces: Double) {
        let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)
        let qualityUnit = HKUnit(from: "fl_oz_us")
        let quantityAmount = HKQuantity(unit: qualityUnit, doubleValue: ounces)
        let today = Date()
        
        let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: today, end: today)
          let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)
          // 4
          let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: today, end: today, objects: [sample])
          // Send water intake data to healthStore…aka ‘Health’ app
          // 5
          self.healthStore?.save(waterCorrelationForWaterAmount, withCompletion: { (success, error) in
            if (error != nil) {
                NSLog("error occurred saving water data")
            }
          })
        
    }
    
    func readYesterdaysWater () {
        guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            return
        }
            
        let predicate = HKQuery.predicateForSamples(withStart: Date.yesterday.morning, end: Date().morning, options: .strictEndDate)
            
        let waterQuery = HKSampleQuery(sampleType: waterType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard error == nil, let quantitySamples = samples as? [HKQuantitySample] else {
                print("Something went wrong: \(error.debugDescription)")
                return
            }
                                              
            let total = quantitySamples.reduce(0.0) {
                $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli))
                
            }
            
            print("total water: \(total)")
            DispatchQueue.main.async {
                PreviousDayViewController.water = total
            }
        }
        if let hs = healthStore {
            hs.execute(waterQuery)
        }
    }
}

extension Date {

    static var yesterday: Date {
        return Date().dayBefore
    }
    static var tomorrow:  Date {
        return Date().dayAfter
    }
    var dayBefore: Date
    {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var dayAfter: Date
    {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var midnight: Date
    {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        
    }
    var morning: Date
    {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var month: Int
    {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool
    {
        return dayAfter.month != month
    }
}
