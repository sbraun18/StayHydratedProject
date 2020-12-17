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
    
    func readYesterdaysWater () -> Double {
        //rest of the code will be here
        var waterAmount = 0.0
        let readData = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        ])
        let calendar = NSCalendar.current
                
        var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                
        anchorComponents.day! -= 1
        guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
            fatalError("*** unable to create a valid date from the given components ***")
        }
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
                fatalError("*** Unable to create a water count type ***")
        }
        let interval = NSDateComponents()
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .mostRecent, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
                
        query.initialResultsHandler = {
            query, results, error in
                    
            guard let statsCollection = results else {
                fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                        
            }
            statsCollection.enumerateStatistics(from: Date.yesterday, to: Date.tomorrow) { statistics, stop in
                if let quantity = statistics.averageQuantity() {
                    let date = statistics.startDate
                    //for: E.g. for steps it's HKUnit.count()
                    let value = quantity.doubleValue(for: HKUnit(from: "fl_oz_us"))
                    print("done")
                    print(value)
                    print(date)
                    waterAmount = value
                }
            }
        }
        return waterAmount
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
        return Calendar.current.date(bySettingHour: 24, minute: 0, second: 0, of: self)!
        
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
