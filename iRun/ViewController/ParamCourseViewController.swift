//
//  ParamCourseViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class ParamCourseViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
