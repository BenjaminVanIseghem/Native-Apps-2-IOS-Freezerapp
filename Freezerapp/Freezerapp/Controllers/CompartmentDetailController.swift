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
    var itemList = [ItemModel]()
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
        
        firebaseAPI.getCompartment(id: (freezer?.id)!){
            compList in
                compList.forEach({ (comp) in
                    self.titles.append(comp.name!)
                    
                    //Empty item list before calling to fetch items for a new compartment
                    self.itemList.removeAll()
                    //Load the items of the compartment
                    self.firebaseAPI.getItems(id: comp.id!){
                        itemList in
                        //Add the items to the compartment
                        self.itemList = itemList
                        comp.items = itemList
                        //Add the compartment to the list
                        self.compList.append(comp)
                        //Clear the list of names every iteration
                        self.itemNames.removeAll()
                        //Loop itemList to add each itemName to a list
                        itemList.forEach({ (item) in
                            self.itemNames.append(item.name!)
                            self.itemQuantities.append(String(item.quantity!))
                        })
                        //Add the itemslist to the 2D array
                        self.table2DArray.append(self.itemNames)
                        //Reload the tableView to see changes
                        self.tableView.reloadData()
                    }
                })
            //Reload the TableView
            self.tableView.reloadData()
        }
        //Register cells
        tableView.register(CompartmentViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(CompartmenViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Compartment", style: .plain, target: self, action: #selector(self.addComp))
    }
    
    //    //Declare the header for each section
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CompartmenViewHeader
            //Set parameters for the header
            header.nameLabel.text = titles[section]
            header.backgroundColor = .lightGray
            
            //Set the TableViewController from the header
            header.compTableViewController = self
            //Set the compId for each header
            header.compId = compList[section].id
            //Set the headerId for each header to know the position in the 2D array
            header.headerId = section
            
            return header
        }
    
    //Declare the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return table2DArray.count
    }
    
    //Declare the number of element per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.compList.count
        return table2DArray[section].count
    }
    
    //Declare the cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompartmentViewCell
        
        //Set the label for the cell
        let title = table2DArray[indexPath.section][indexPath.row]
        //let quantity = itemQuantities[indexPath.row]
        cell.nameLabel.text = title
        
        return cell
    }
    
    //Get data from add button and add new item
    func addItem(compId: String, name : String, quantity : Int, section : Int){
//        //Add the item to Firebase
//        firebaseAPI.uploadItem(compId: compId, name: name, quantity: quantity)
//        //Create the index path where the item will be added
//        let insertionIndexPath = NSIndexPath(row: self.table2DArray[section].count + 1, section: section)
//        //Insert the rows with automatic animation
//        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
//        //Reload the tableView
//        self.tableView.reloadData()
    }
    
    @objc func addComp(){
        print("Compartment added")
        //Create alert to get info
        
        //Pass alert textfields to method for adding compartment to firebase
    }
    
    //Method for adding compartment to firebase and reloading the tableview
    func addCompToFirebase(){
        //Pass comp to Firebase
        
        //Reload the tableView
//        self.tableView.reloadData()
    }
}

class CompartmenViewHeader: UITableViewHeaderFooterView{
    var compTableViewController : CompartmentDetailController?
    var compId : String?
    var headerId : Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Create label for compartment name
    let nameLabel: UILabel = {
        let label = UILabel()
        //set paramaters for label
        label.text = "Compartment"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //Create button to add item to this compartment
    let addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupView(){
        addSubview(nameLabel)
        addSubview(addItemButton)
        
        addItemButton.addTarget(self, action: #selector(CompartmenViewHeader.addItem), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": addItemButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": addItemButton]))
    }
    
    
    var itemNameTextField : UITextField!
    var itemQuantityTextField : UITextField!
    
    func itemNameTextField(textField : UITextField!){
        itemNameTextField = textField
        itemNameTextField.placeholder = "Item name"
    }
    func itemQuantityTextField(textField : UITextField){
        itemQuantityTextField = textField
        itemQuantityTextField.placeholder = "Quantity"
    }
    @objc func addItem(){
        
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Add Item", message: "Add Item", preferredStyle: .alert)
        
        //Initialize the actions
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        
        //Add textfields to the alert to pass strings
        alert.addTextField(configurationHandler: itemNameTextField)
        alert.addTextField(configurationHandler: itemQuantityTextField)
        
        compTableViewController?.present(alert, animated : true, completion : nil)
    }
    
    func save(alert : UIAlertAction){
        let name = itemNameTextField.text! as String
        let quantity = itemQuantityTextField.text! as String
        
        compTableViewController?.addItem(compId: compId!, name: name, quantity: Int(quantity)!, section : headerId!)
    }
}

class CompartmentViewCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Create label for item name
    let nameLabel: UILabel = {
        let label = UILabel()
        //set paramaters for label
        label.text = "Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    func setUpView(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}


//TODO
/*
    Create swiping animation to delete items
    Create delete button to delete an entire compartment with all its items
 
    Animation to make the app fancy
 */
