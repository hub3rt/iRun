//
//  StatsViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import CoreData
import Charts

class StatsViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var askingDist = false, askingTemps = true
    
    private var courses: NSSet?
    
    @IBOutlet weak var tempsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var vitesseLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = retrieveCoursesFor(_typeDeCourse: retrieveTypesDeCourse()![0])
        
        lineChartView.noDataText = "Aucune donnée trouvée pour ce type de course"
        
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
        var temps = 0.0000
        var distance = 0.0
        var vitesse = 0.0
        
        for _c in courses! {
            if let course = _c as? Course {
                temps += course.duree!.doubleValue
                distance += course.distance!.doubleValue
                vitesse += course.vitesse!.doubleValue
            }
        }
        
        if (courses!.count != 0)
        {
            temps = temps / Double(courses!.count)
            distance = distance / Double(courses!.count)
            vitesse = vitesse / Double(courses!.count)
        }
        
        let heures = Int(temps)
        let minutes = Int((temps - Double(heures)) * 100.0)
        let secondes = Int((((temps - Double(heures)) * 100.0) - Double(minutes)) * 100.0)
        
        tempsLabel.text = "\(heures < 10 ? "0\(heures)" : String(heures)):\(minutes < 10 ? "0\(minutes)" : String(minutes)):\(secondes < 10 ? "0\(secondes)" : String(secondes))"
        
        let km = Int(distance)
        let m = Int((distance - Double(km)) * 100.0)
        
        distanceLabel.text = "\(km),\(m < 10 ? "0\(m)" : String(m)) km"
        
        let kmh = Int(vitesse)
        let mh = Int((vitesse - Double(kmh)) * 100.0)
        
        vitesseLabel.text = "\(kmh),\(mh < 10 ? "0\(mh)" : String(mh)) km/h"
        
        var dataEntries: [ChartDataEntry] = []
        var xValues: [String] = []
        
        if (courses!.count != 0) {
            var cpt = 0;
            
            for _c in courses! {
                if let course = _c as? Course {
                    let dataEntry = ChartDataEntry(x: Double(cpt), y: askingDist ? course.distance!.doubleValue : course.duree!.doubleValue)
                    dataEntries.append(dataEntry)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    xValues.append(dateFormatter.string(from: course.date! as Date))
                    cpt += 1;
                }
            }
            
            let lineChartDataSet = LineChartDataSet(values: dataEntries, label: askingDist ? "distance" : "temps")
            let lineChartData = LineChartData(dataSet: lineChartDataSet)
            
            lineChartView.data = lineChartData
            
            lineChartView.xAxis.granularity = 1
            lineChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (index, _) -> String in
                return xValues[Int(index)]
            })
        } else {
            lineChartView.data = nil
        }
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
        courses = retrieveCoursesFor(_typeDeCourse: retrieveTypesDeCourse()![row])
        
        draw()
    }

}
