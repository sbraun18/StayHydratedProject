//
//  WaterLogViewController.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

import UIKit
import HealthKit

class WaterLogViewController: UIViewController {
    var settings = Settings()
    var waterLevel = 0.0

    
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
                
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "SettingsSegue" {
                
            }
            else if identifier == "AddDrinkSegue" {
                
                
            }
            else if identifier == "PreviousDaySegue" {
                
            }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
