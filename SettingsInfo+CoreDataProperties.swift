//
//  SettingsInfo+CoreDataProperties.swift
//  FinalProject
//
//  Created by Sophia Braun on 12/16/20.
//
//

import Foundation
import CoreData


extension SettingsInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsInfo> {
        return NSFetchRequest<SettingsInfo>(entityName: "SettingsInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Date?
    @NSManaged public var height: Double
    @NSManaged public var weight: Double

}

extension SettingsInfo : Identifiable {
    
}
