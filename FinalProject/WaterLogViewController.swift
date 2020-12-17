//
//  WaterLogViewController.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

import UIKit
import HealthKit
import CoreData

@available(iOS 13.0, *)
class WaterLogViewController: UIViewController {
    var settings = Settings()
    var waterLevel = 0.0
    private var healthStore: HealthStore?
    var setting = [SettingsInfo]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var hydrationLabelLabel: UILabel!
    
    @IBOutlet var waterCupImage: UIImageView!
    
    @IBAction func addDrink (_ sender: UIButton) {
        // addDrink
    }
    
    @IBAction func unwindFromAddDrinkViewController (segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if (identifier == "SaveDrink") {
                let waterLevel = setWaterLevel(alcDrinks: AddDrinkViewController.alcDrinks, hydrateDrinks: AddDrinkViewController.hydrateDrinks, dehydrateDrinks: AddDrinkViewController.dehydrateDrinks)
                changeImage(waterLevel: waterLevel)
                storeWater(hydrateDrinks: AddDrinkViewController.hydrateDrinks)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func storeWater(hydrateDrinks: [HydratingDrinks]) {
        var waterAmount: Double = 0.0
        for water in hydrateDrinks {
            if water.type == "Water" {
                waterAmount += water.amount
            }
            if let healthstore = healthStore {
                healthstore.addWater(ounces: waterAmount)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "SettingSegue" {
                if let settingVC = segue.destination as? SettingsViewController {
                    let set = setting[0]
                    settingVC.setting = set
                }
            }
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        var newSetting = SettingsInfo(context: self.context)
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
    
    func setWaterLevel (alcDrinks: [AlcoholicDrinks], hydrateDrinks: [HydratingDrinks], dehydrateDrinks: [DehydratingDrinks])  -> Double {
        var hydrationPercent = 0.0
        var caffienePercent = 0.0
        var alcPercent = 0.0
        var hydrateAmount = 0.0
        var caffieneAmount = 0.0
        var alcAmmount = 0.0
        var waterLevel = 0.0
        let alcCount = Double(alcDrinks.count)
        let caffieneCount = Double(dehydrateDrinks.count)
        let hydrateCount = Double(hydrateDrinks.count)
        
        if (!alcDrinks.isEmpty) {
            for alc in alcDrinks {
                alcPercent += alc.alcPercent
                alcAmmount += alc.amount
            }
            
            alcPercent = alcPercent / alcCount
            alcAmmount = (alcAmmount - (alcAmmount * alcPercent))
        }
        if (!hydrateDrinks.isEmpty) {
            for water in hydrateDrinks {
                if (water.type != "Water") {
                    hydrationPercent += water.hydratePercent
                    hydrateAmount += water.amount
                }
                hydrationPercent += 0.50
                hydrateAmount += water.amount
            }
            
            hydrationPercent = hydrationPercent / hydrateCount
            hydrateAmount = hydrateAmount + hydrationPercent
        }
        if (!dehydrateDrinks.isEmpty) {
            for caffine in dehydrateDrinks {
                caffienePercent += caffine.caffeinePercentage
                caffieneAmount += caffine.amount
            }
            
            caffienePercent = caffienePercent / caffieneCount
            caffieneAmount = (caffieneAmount - (caffieneAmount * caffienePercent))
        }
        
        waterLevel = hydrateAmount
        waterLevel = (waterLevel - caffieneAmount) - alcAmmount
        return waterLevel
    }
    
    func changeImage (waterLevel: Double) {
        print("Water Level is \(waterLevel)")
        if (waterLevel < 0) {
            waterCupImage.image = UIImage(named: "waterCup0")
        }
        else if (waterLevel > 0 && waterLevel < 20) {
            waterCupImage.image = UIImage(named: "waterCup1")
        }
        else if (waterLevel > 20 && waterLevel < 40) {
            waterCupImage.image = UIImage(named: "waterCup2")
        }
        else if (waterLevel > 40 && waterLevel < 60) {
            waterCupImage.image = UIImage(named: "waterCup3")
        }
        else if (waterLevel > 60 && waterLevel < 80) {
            waterCupImage.image = UIImage(named: "waterCup4")
        }
        else if (waterLevel > 80 && waterLevel < 100) {
            waterCupImage.image = UIImage(named: "waterCup5")
        }
        else if (waterLevel > 100 && waterLevel < 120) {
            waterCupImage.image = UIImage(named: "waterCup6")
        }
        else if (waterLevel > 120) {
            waterCupImage.image = UIImage(named: "waterCup7")
        }
    }


}
