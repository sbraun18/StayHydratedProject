//
//  PreviousDayViewController.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

import UIKit
import CoreData
import HealthKit

class PreviousDayViewController: UIViewController {
    var setting = [SettingsInfo]()
    var settingOptional: SettingsInfo? = nil
    
    private var healthStore: HealthStore?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var hydrationLevelLabel: UILabel!
    @IBOutlet var previousDayLabel: UILabel!

    override func viewDidDisappear(_ animated: Bool) {
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isInfoShown = UserDefaults.standard.string(forKey: "Info")
        if (isInfoShown == nil || isInfoShown == "") {
            UserDefaults.standard.setValue("ShownInfo", forKey: "Info")
            getAlerts()
            healthStore = HealthStore()
            
            if let healthStore = healthStore {
                healthStore.requestCaffeineAuthorization { (success) in
                    
                }
                healthStore.requestWaterAuthorization { (success) in
                    
                }
            }
        }
        let alertShown = UserDefaults.standard.bool(forKey: "ShownAlert")
        if !alertShown {
            print("1st time launch, showing info Alert.")
            UserDefaults.standard.set(true, forKey: "ShownAlert")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
   
    func getAlerts () {
        let nameAlert = UIAlertController(title: "Enter your name.", message: nil, preferredStyle: .alert)
        nameAlert.addTextField { (textField) in
            textField.placeholder = "Enter your name."
        }
        nameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            if let alertText = nameAlert.textFields, let first = alertText.first, let text = first.text {
                Settings.setName(name: text)
                
                let birthdayAlert = UIAlertController(title: "Enter your birthday to claculate how much water you need to drink.", message: nil, preferredStyle: .alert)
                birthdayAlert.addTextField (configurationHandler: { textField in
                    textField.placeholder = "Enter a Start Date MM/DD/YYYY"
                })
                birthdayAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                    let text = birthdayAlert.textFields?.first?.text
                    Settings.setAge(birthday: text)
                    
                    let heightAlert = UIAlertController(title: "Enter your height.", message: nil, preferredStyle: .alert)
                    heightAlert.addTextField { (textField) in
                        textField.placeholder = "Enter your height."
                    }
                    heightAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                        if let alertText = heightAlert.textFields, let first = alertText.first, let text = first.text {
                            Settings.setHeight(height: text)
                            
                            let weightAlert = UIAlertController(title: "Enter your weight to claculate how much water you need to drink.", message: nil, preferredStyle: .alert)
                            weightAlert.addTextField { (textField) in
                                textField.placeholder = "Enter your weight."
                            }
                            weightAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                                if let alertText = weightAlert.textFields, let first = alertText.first, let text = first.text {
                                    Settings.setWeight(weight: text)
                                }
                            }))
                            self.present(weightAlert, animated: true)
                        }
                    }))
                    self.present(heightAlert, animated: true)
                }))
                self.present(birthdayAlert, animated: true)
            }
        }))
        self.present(nameAlert, animated: true)
        if let settings = settingOptional {
            var (_,setAge) = Settings.getAge()
            var setName =  Settings.getName()
            var (_, setHeight) = Settings.getHeight()
            var (_, setWeight) = Settings.getWeight()
            
            settings.age = setAge
            settings.weight = setWeight
            settings.height = setHeight
            settings.name = setName
        }
        saveSettings()
    }
    
    func saveSettings () {
        do {
            try context.save()
        }
        catch {
            print("error saving settings \(error)")
        }
    }
    
    /*
     the read portion of CRUD
     
     */
    
    func loadSettings () {
        let request: NSFetchRequest<SettingsInfo> = SettingsInfo.fetchRequest()
        do {
            setting = try context.fetch(request)
        }
        catch {
            print("Error loading settings \(error)")
        }
    }
}



