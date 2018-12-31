//
//  CompartmentDetailController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 30/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

class CompartmentDetailController : UITableViewController{
    
    //Parameters
    let firebaseAPI = FirebaseAPI()
    var compList = [CompartmentModel]()
    var table2DArray = [[String]]()
    var freezer : FreezerModel?
    let cellId = "cellId"
    let headerId = "headerId"
    var titles = [String]()
    var itemNames = [String]()
    var itemQuantities = [String]()
    
    //On loading fo the view, fetch the compartments and their items
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = freezer?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /*
            DON'T FORGET WHEN ADDING OBSERVERS
            -> Empty all temp arrays
            -> Make sure it works asynchronous
        */
    
        
        firebaseAPI.getCompartments(id: (freezer?.id)!){
            compList in
                self.compList.removeAll()
                self.titles.removeAll()
                compList.forEach({
                    (comp) in
                    self.titles.append(comp.name!)
                    self.compList.append(comp)
                })
            //let indexSet = IndexSet(0..<(compList.count-1))
            //self.tableView.reloadSections(indexSet, with: UITableView.RowAnimation.left)
            //Fetch the items for the compartments
            self.fetchItems()
            self.tableView.reloadData()
        }
        
        //Register cells
        tableView.register(CompartmentViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(CompartmenViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Compartment", style: .plain, target: self, action: #selector(self.addComp))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "refresh", style: .plain, target: self, action: #selector(self.refresh))
    }
    
    //    //Declare the header for each section
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if compList.count == titles.count {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CompartmenViewHeader
                //Set parameters for the header
                header.nameLabel.text = titles[section]
                header.backgroundView?.backgroundColor = .lightGray
                
                //Set the TableViewController from the header
                header.compTableViewController = self
                //Set the compId for each header
                header.compId = compList[section].id
                //Set the headerId for each header to know the position in the 2D array
                header.headerId = section
                
                return header
            }
            else {
                let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
                return h
            }
        }
    
    //Declare the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !compList.isEmpty {
            return compList.count
        }
        else {
            return 0
        }
    }
    
    //Declare the number of element per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.compList.count
        if  table2DArray.count == compList.count {
            return table2DArray[section].count
        }
        else{
            return 0
        }
        
    }
    
    //Declare the cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompartmentViewCell
        
        //Set the label for the cell if array is not empty
        if !table2DArray.isEmpty {
            let title = table2DArray[indexPath.section][indexPath.row]
            //let quantity = itemQuantities[indexPath.row]
            cell.nameLabel.text = title
        }
        return cell
    }
    
    //Initialize UI components for alert to add compartment
    var compNameTextField : UITextField!
    func compNameTextField(textField : UITextField!){
        compNameTextField = textField
        compNameTextField.placeholder = "Compartment name"
    }
    
    //Objective C function used by navigationBarItem
    @objc func addComp(){
        //Create alert to get info
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Add Compartment", message: "Add Compartment", preferredStyle: .alert)
        
        //Initialize the actions
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.addCompToFirebase)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        
        //Add textfields to the alert to pass strings
        alert.addTextField(configurationHandler: compNameTextField)
        
        self.present(alert, animated : true, completion : nil)
        //Pass alert textfields to method for adding compartment to firebase
    }
    
    //Method for adding compartment to firebase and reloading the tableview
    func addCompToFirebase(alert : UIAlertAction){
        //Extract name from alert
        let name = compNameTextField.text! as String
        //Pass comp to Firebase
        firebaseAPI.uploadCompartment(freezerId: (freezer?.id)!, name: name)
    }
    
    //Get data from add button and add new item
    func addItem(compId: String, name : String, quantity : Int, section : Int){
        //        //Add the item to Firebase
        firebaseAPI.uploadItem(compId: compId, name: name, quantity: quantity)
        //        //Create the index path where the item will be added
        //        let insertionIndexPath = NSIndexPath(row: self.table2DArray[section].count + 1, section: section)
        //        //Insert the rows with automatic animation
        //        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
        //        //Reload the tableView
        //        self.tableView.reloadData()
    }
    
    
    //Custom function to refresh all the rows
    func refreshAllRows(){
        var indexPathsToReload = [IndexPath]()
        //Iterate over every row in every section
        for section in table2DArray.indices {
            for row in table2DArray[section].indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        //Reload all the rows
        self.tableView.reloadRows(at: indexPathsToReload, with: .left)
    }
    
    //Make refresh function
    @objc func refresh(){
        self.tableView.reloadData()
    }
    
    
    //Make a func to fetch the items of comps
    //ONLY CALL THIS WHEN COMPLIST ISN'T ZERO
    func fetchItems(){
        if !compList.isEmpty{
            //Empty array to refill
            self.table2DArray.removeAll()
            for (index, comp) in compList.enumerated() {
                //Call observer for items
                self.firebaseAPI.getItems(id: comp.id!){
                    itemList in
                    //Add the items to the compartment
                    comp.items = itemList
                    //Clear the list of names every iteration
                    self.itemNames.removeAll()
                    //Loop itemList to add each itemName to a list
                    itemList.forEach({
                        (item) in
                        self.itemNames.append(item.name!)
                        self.itemQuantities.append(String(item.quantity!))
                    })
                    //Add the itemslist to the 2D array
                    //If the array at the index is empty, add the list of name
                    //else change the existing list
                    if (self.table2DArray.count - 1) < index {
                        self.table2DArray.append(self.itemNames)
                    } else {
                        self.table2DArray[index] = self.itemNames
                    }
                    
                    //Reload the tableView to see changes
                    self.tableView.reloadData()
                    //self.refreshAllRows()
                }
            }
        }
        else {
            print("Error: compList is still empty")
        }
    }
    
}

//TODO
/*
    Create swiping animation to delete items
    Create delete button to delete an entire compartment with all its items
 
    Animation to make the app fancy
 */
