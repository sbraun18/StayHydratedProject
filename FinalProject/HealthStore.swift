//
//  HealthStore.swift
//  FinalProject
//
//  Created by Rebekah Hale on 12/2/20.
//

import Foundation
import HealthKit

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
}

