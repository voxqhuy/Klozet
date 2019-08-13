//
//  ItemEditViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit

class ItemEditViewController: UIViewController {

    @IBOutlet var itemImageView: UIImageView!
    
    var newItemImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Item edit"
        
        navigationItem.leftBarButtonItem?.title = "Cancel"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if newItemImage != nil {
            itemImageView.image = newItemImage
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
