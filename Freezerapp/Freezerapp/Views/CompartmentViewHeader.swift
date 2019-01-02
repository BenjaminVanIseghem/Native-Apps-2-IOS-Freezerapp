//
//  CompartmentViewHeader.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 31/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

//Delegate to match an action to the toggling of the header
protocol CompartmentViewHeaderDelegate {
    func toggleSection(header: CompartmenViewHeader, section: Int)
}

class CompartmenViewHeader: UITableViewHeaderFooterView{
    var delegate: CompartmentViewHeaderDelegate?
    var compTableViewController : CompartmentDetailController?
    var compId : String?
    var headerId : Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
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
        //Make sure the label resizes according to the constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    //Create button to add item to this compartment
    let addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: [])
        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupView(){
        //Add the views to the main view
        addSubview(nameLabel)
        addSubview(addItemButton)
        
        //Add an action to the button
        addItemButton.addTarget(self, action: #selector(CompartmenViewHeader.addItem), for: .touchUpInside)
        
        //Add the horizontal constraints for the label and the button
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": nameLabel, "v1": addItemButton]))
        
        //Add the vertical constraints for the label and the button
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": addItemButton]))
    }
    
    //Text fields inside the alert that is called by the add button
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
    
    //Objective C function to add an item via an alert
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
    
    //Function called by the alert to handle the save
    func save(alert : UIAlertAction){
        let name = itemNameTextField.text! as String
        let quantity = itemQuantityTextField.text! as String
        
        compTableViewController?.addItem(compId: compId!, name: name, quantity: Int(quantity)!, section : headerId!)
    }
    
    //Handles the toggle gesture
    @objc func selectHeaderView(gesture: UITapGestureRecognizer){
        let cell = gesture.view as! CompartmenViewHeader
        delegate!.toggleSection(header: self, section: cell.headerId!)
    }
}

/*
 Important things when creating UI Views programmatically
 
 - Create the views with their correct parameters (title, backgroundcolor, textcolor, resizable, etc.)
 - Add the newly created views as a subview to the parent
 - Set the constraints of the subviews
 (- If you create a button, also create an action that happens when it's clicked)
 */
