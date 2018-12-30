//
//  CompartmentDetailController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 30/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

class CompartmentDetailController : UITableViewController{
    
    let firebaseAPI = FirebaseAPI()
    var compList = [CompartmentModel]()
    var freezer : FreezerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Compartments"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        firebaseAPI.getCompartment(id: (freezer?.id)!){
            compList in
            
            self.compList = compList
            
            print(compList.count)
            //TODO: Reload the TableView
            //self.tblCompartments.reloadData()
        }
    }
    
}
