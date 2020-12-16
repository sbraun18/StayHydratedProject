//
//  ViewController.swift
//  FinalProject
//
//  Created by Rebekah Hale on 11/30/20.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class SettingsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var setting: SettingsInfo? = nil

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    
    
    @IBAction func saveButton (_ sender: UIButton) {
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        _ = Date()
        
        if let settings = setting , let birthday = settings.age as Date? {
            nameTextField.text = settings.name
            heightTextField.text = String(settings.height)
            weightTextField.text = String(settings.weight)
            ageTextField.text = dateFormatter.string(from: birthday)
        }
        
    }

    /*
     saves the trips using core data
     
     */
    func saveSettings(context: NSManagedObjectContext) {
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
    

}

