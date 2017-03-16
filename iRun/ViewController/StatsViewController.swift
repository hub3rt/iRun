//
//  StatsViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var askingDist = false, askingTemps = true
    
    @IBOutlet weak var tempsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var vitesseLabel: UILabel!
    
    @IBOutlet weak var statsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let courses = retrieveCoursesFor(_typeDeCourse: retrieveTypesDeCourse()![0])
        
        print("\(courses!.count)")
        
        draw()
    }
    
    @IBAction func selectTemps(_ sender: Any) {
        if (askingTemps == false) {
            draw()
        }
        askingTemps = true
        askingDist = false
    }
    
    @IBAction func selectDist(_ sender: Any) {
        if (askingDist == false) {
            draw()
        }
        askingDist = true
        askingTemps = false
    }
    
    func draw () {
        print("Draw")
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func retrieveCoursesFor (_typeDeCourse: String) -> NSSet? {
        let fetchRequest: NSFetchRequest<TypeDeCourse> = TypeDeCourse.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nom == %@", _typeDeCourse)
        
        do {
            let result = try getContext().fetch(fetchRequest).first! as TypeDeCourse
            
            return result.courses
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    func retrieveTypesDeCourse () -> Array<String>? {
        if let path = Bundle.main.path(forResource: "typesDeCourses", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let types = dic["typesDeCourse"] as? Array<String> {
                    return types
                }
            }
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return retrieveTypesDeCourse()!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return retrieveTypesDeCourse()![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let courses = retrieveCoursesFor(_typeDeCourse: retrieveTypesDeCourse()![row])
        
        print("\(courses!.count)")
    }

}
