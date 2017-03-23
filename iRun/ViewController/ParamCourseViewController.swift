//
//  ParamCourseViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ParamCourseViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var sliderActivateVoice: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveTypesDeCourse () -> Array<String>? {
        let types = fetchTypeDeCourse()
        
        if (types != nil && types!.count > 0)
        {
            var result: Array<String> = []
            for type in types! {
                result.append(type.nom!)
            }
            return result
        }
        return nil
    }
    
    func retrieveZooms () -> Array<NSNumber>? {
        if let path = Bundle.main.path(forResource: "typesDeCourses", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let zooms = dic["zoom"] as? Array<NSNumber> {
                    return zooms
                }
            }
        }
        return nil
    }
    
    func fetchTypeDeCourse () -> Array<TypeDeCourse>? {
        let fetchRequest: NSFetchRequest<TypeDeCourse> = TypeDeCourse.fetchRequest()
        
        do {
            let result = try getContext().fetch(fetchRequest)
            return result
        } catch {
            print("Error with request: \(error)")
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
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startRun") {
            if let destination = segue.destination as? CourseViewController {
                let voiceActive = sliderActivateVoice.isOn
                let zoom = retrieveZooms()![pickerView.selectedRow(inComponent: 0)]
                let type = fetchTypeDeCourse()![pickerView.selectedRow(inComponent: 0)]
                
                destination.regionRadius = CLLocationDistance(zoom.intValue)
                destination.isVoiceActive = voiceActive
                destination.typeDeRun = type
            }
        }
    }

}
