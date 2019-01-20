//
//  CompartmentDetailController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 30/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//
import UIKit

//Struct to keep metadata about the expanded state of headers
struct tableData{
    var isExpanded = Bool()
    var headerName = String()
    var names = [String]()
    var quantities = [String]()
    var itemIds = [String]()
    var compId = String()
}

class CompartmentDetailController : UITableViewController, CompartmentViewHeaderDelegate{
    //Expands or collapses the section
    func toggleSection(header: CompartmenViewHeader, section: Int) {
        
        var indexPaths = [IndexPath]()
        for row in itemData[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = itemData[section].isExpanded
        itemData[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    
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
    var itemIds = [String]()
//    var refreshControl: UIRefreshControl?
    
    //Array of all items with header and expanded state info
    var itemData = [tableData]()
    
    //On loading fo the view, fetch the compartments and their items
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = freezer?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //fetch compartments and add them to the freezer
        fetchCompartments()
        
        //Register cells
        tableView.register(CompartmentViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(CompartmenViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        //Add navigation components
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Compartment",
            style: .plain,
            target: self,
            action: #selector(self.addComp))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: "refresh",
//            style: .plain,
//            target: self,
//            action: #selector(self.refreshAllRows))
        
        //Add the pull to refresh functionality
        addRefreshControl()
    }
    
    //    //Declare the header for each section
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if itemData.count > section{
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CompartmenViewHeader

                //Set parameters for the header
                header.nameLabel.text = itemData[section].headerName
                header.backgroundView?.backgroundColor = .lightGray
                
                header.delegate = self
                //Set the TableViewController from the header
                header.compTableViewController = self
                //Set the compId for each header
                header.compId = itemData[section].compId
                //Set the headerId for each header to know the position in the 2D array
                header.headerId = section
                
                return header
            }
            else {
                let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
                return h
            }
        }
    
    
    //Set the height for each header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //Set the height of each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //Declare the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !itemData.isEmpty {
            return itemData.count
        } else {
            return 0
        }
    }
    
    //Declare the number of element per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !itemData[section].isExpanded {
            return 0
        } else {
            return itemData[section].names.count
        }
        
    }
    
    //Declare the cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompartmentViewCell

        cell.row = indexPath.row
        cell.section = indexPath.section
        cell.compTableViewController = self
        
        if !itemData.isEmpty {
            let title = itemData[indexPath.section].names[indexPath.row]
            let quantity = itemData[indexPath.section].quantities[indexPath.row]
            cell.nameLabel.text = title
            cell.quantityLabel.text = quantity
            cell.compId = itemData[indexPath.section].compId
            cell.itemId = itemData[indexPath.section].itemIds[indexPath.row]
        }
        
        return cell
    }
    
    //Delete an item from the tableview and the firebase database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let i = freezer?.compartments?[indexPath.section].items![indexPath.row]
            guard i != nil else {
                print("Error while deleting item, nil")
                return
            }
            let compId = freezer?.compartments?[indexPath.section].id
            firebaseAPI.deleteItem(compId: compId!, i: i!)
            
            self.tableView.reloadData()
        }
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
        //Add the item to Firebase
        firebaseAPI.uploadItem(compId: compId, name: name, quantity: quantity)
    }
    //Delete compartment with ID
    func deleteCompartment(compId: String, position: Int){
        firebaseAPI.deleteAllItemsOfCompartment(compId: compId)
        firebaseAPI.deleteCompartment(freezerId: (freezer?.id)!, c: compId)
        itemData.remove(at: position)
    }
    
    
    //Custom function to refresh all the rows
    @objc func refreshAllRows(){
        var indexPathsToReload = [IndexPath]()
        //Iterate over every row in every section
        for section in itemData.indices {
            for row in itemData[section].names.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        
        let sectionSet = IndexSet(integersIn: 0..<self.itemData.count)
        //Stop refreshing animation
        refreshControl?.endRefreshing()
        //Reload all the rows
        self.tableView.reloadSections(sectionSet, with: .left)
    }
    
    //Make a func to fetch the items of comps
    //ONLY CALL THIS WHEN COMPLIST ISN'T ZERO
    func fetchItems(){
        if !compList.isEmpty{
            for (index, comp) in compList.enumerated() {
                //Call observer for items
                self.firebaseAPI.getItems(id: comp.id!){
                    itemList in
                    //Add the items to the compartment
                    comp.items = itemList
                    self.freezer?.compartments?[index].items = itemList
                    //Clear the list of names every iteration
                    self.itemNames.removeAll()
                    self.itemQuantities.removeAll()
                    self.itemIds.removeAll()
                    //Loop itemList to add each itemName to a list
                    itemList.forEach({
                        (item) in
                        self.itemNames.append(item.name!)
                        self.itemQuantities.append(String(item.quantity!))
                        self.itemIds.append(item.id!)
                    })
                    
                    //insert into itemData
                    self.insertIntoItemData(
                        itemNames: self.itemNames,
                        itemQuantities: self.itemQuantities,
                        index: index,
                        headerName: comp.name!,
                        compId: comp.id!,
                        itemIds: self.itemIds
                    )
                    
                    //Reload the tableView to see changes
                    self.tableView.reloadData()
                }
            }
        }
        else {
            print("Error: compList is still empty")
        }
    }
    
    //Function to fetch the compartments of the chosen freezer
    func fetchCompartments(){
        firebaseAPI.getCompartments(id: (freezer?.id)!){
            compList in
            self.freezer?.compartments = compList
            self.compList.removeAll()
            self.titles.removeAll()
            compList.forEach({
                (comp) in
                
                self.titles.append(comp.name!)
                self.compList.append(comp)
            })
            //Fetch the items for the compartments
            self.fetchItems()
            self.tableView.reloadData()
        }
    }
    
    //Insert all the names, quantities, id, in the itemData array
    func insertIntoItemData(itemNames: [String], itemQuantities: [String], index: Int, headerName: String, compId: String, itemIds: [String]){
        if (itemData.count - 1) < index {
            itemData.append(tableData(isExpanded: true, headerName: headerName, names: itemNames, quantities: itemQuantities, itemIds: itemIds, compId: compId))
        } else {
            itemData[index].names = itemNames
            itemData[index].quantities = itemQuantities
            itemData[index].itemIds = itemIds
        }
    }
    
    //UI object to control the refresh
    //This is used for the pull down to refresh functionality
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshAllRows), for: .valueChanged)
        
        tableView.addSubview(refreshControl!)
    }
    
    //Edit a compartment name
    func editCompartment(compId: String, compName: String, position: Int){
        firebaseAPI.editCompartment(freezerId: (freezer?.id)!, compId: compId, compName: compName)
        itemData[position].headerName = compName
    }
    
    //Edit an item name
    func editItemName(compId: String, itemId: String, itemName: String, section: Int, row : Int){
        firebaseAPI.editItemName(compId: compId, itemId: itemId, itemName: itemName)
        itemData[section].names[row] = itemName
    }
}

/*
 DON'T FORGET WHEN ADDING OBSERVERS
 -> Empty all temp arrays
 -> Make sure it works asynchronous
 */
