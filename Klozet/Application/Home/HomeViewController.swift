//
//  HomeViewController.swift
//  Klozet
//
//  Created by Developers on 8/1/19.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func deleteCoreDataTapped(_ sender: UIButton) {
        // RIGHT NOW it only deletes all items
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let myCoreData = MyCoreData(modelName: "Klozet")
            let managedContext = myCoreData.managedContext
            let results = try managedContext.fetch(fetchRequest)
            for item in results {
                managedContext.delete(item)
            }
            myCoreData.saveContext()
        } catch  {
            print("voxerror. Failed to detele all Core Data")
        }
    }
    

}

