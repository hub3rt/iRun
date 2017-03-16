//
//  StatsViewController.swift
//  iRun
//
//  Created by Developer on 16/03/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let marches = retrieveCoursesFor(_typeDeCourse: "marche")
        
        print("\(marches!.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
