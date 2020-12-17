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
    //var settingsArr = [SettingsInfo]()
    
    private var healthStore: HealthStore?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let entity = NSEntityDescription.entity(forEntityName: "SettingInfo", in: self.context)
    //let newUser = NSManagedObject(entity: entity!, insertInto: context)
    
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
        //let entity = NSEntityDescription.entity(forEntityName: "SettingInfo", in: context)
        //let newUser = NSManagedObject(entity: entity!, insertInto: context)
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
        if let identifier = segue.identifier {
            if identifier == "SettingSegue" {
            }
                
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        let newSetting = SettingsInfo(context: self.context)
        newSetting.name = Settings.getName()
        newSetting.age = Settings.getAge().1
        newSetting.height = Settings.getHeight().1
        newSetting.weight = Settings.getWeight().1
        setting.append(newSetting)
        saveSettings()
    }
   
    func getAlerts () {
        let nameAlert = UIAlertController(title: "Enter your name.", message: nil, preferredStyle: .alert)
        nameAlert.addTextField { (textField) in
            textField.placeholder = "Enter your name."
        }
        nameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            if let alertText = nameAlert.textFields, let first = alertText.first, let text = first.text {
                Settings.setName(name: text)
                //newUser.setValue(Settings.getName(), forKey: "name")
                
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



