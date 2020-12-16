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

    
    @IBOutlet var hydrationLabelLabel: UILabel!
    
    @IBOutlet var giphImage: UIImageView!
    
    @IBAction func addDrink (_ sender: UIButton) {
        // addDrink
    }
    
    @IBAction func unwindFromAddDrinkViewController (segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if (identifier == "SaveDrink") {
                let drinks = AddDrinkViewController.drinks
                print(drinks)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
