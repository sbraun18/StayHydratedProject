//
//  PreviousDayViewController.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

import UIKit
import CoreData
import HealthKit

@available(iOS 13.0, *)
class PreviousDayViewController: UIViewController {
    
    @IBOutlet var hydrationLevelLabel: UILabel!
    @IBOutlet var previousDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        // Do any additional setup after loading the view.
        //let entity = NSEntityDescription.entity(forEntityName: "SettingInfo", in: context)
        //let newUser = NSManagedObject(entity: entity!, insertInto: context)
    }
    
    
}



