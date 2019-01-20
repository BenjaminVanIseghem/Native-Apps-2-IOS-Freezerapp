//
//  CompartmentViewHeader.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 31/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

/*
    THIS CLASS IS TO DEMONSTRATE HOW TO PROGRAMMATICALLY CREATE A TABLEVIEW
 */


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
        let image = UIImage(named: "add_50")

        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        //Add the image and scaling options
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    //Create button to edit the compartment
    let editCompartmentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "edit_50")
        
        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        //Add the image and scaling options
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    //Create button to delete the compartment
    let deleteCompartmentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "trash_50")

        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        //Add the image and scaling options
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    func setupView(){
        //Add the views to the main view
        addSubview(nameLabel)
        addSubview(addItemButton)
        addSubview(editCompartmentButton)
        addSubview(deleteCompartmentButton)
        
        //Add an action to the buttons
        addItemButton.addTarget(self, action: #selector(CompartmenViewHeader.addItem), for: .touchUpInside)
        editCompartmentButton.addTarget(self, action: #selector(CompartmenViewHeader.editCompartment), for: .touchUpInside)
        deleteCompartmentButton.addTarget(self, action: #selector(CompartmenViewHeader.deleteCompartment), for: .touchUpInside)
        
        //Add the horizontal constraints for the label and the button
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v0]-[v1(24)]-16-[v2(24)]-16-[v3(24)]-8-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": nameLabel, "v1": addItemButton, "v2": editCompartmentButton, "v3": deleteCompartmentButton]))
        
        //Add the vertical constraints for the label and the button
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": addItemButton]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": editCompartmentButton]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": deleteCompartmentButton]))
    }
    
    //Text fields inside the alert that is called by the add button
    var itemNameTextField : UITextField!
    var itemQuantityTextField : UITextField!
    var compNameTextField : UITextField!
    
    func itemNameTextField(textField : UITextField!){
        itemNameTextField = textField
        itemNameTextField.placeholder = "Item name"
    }
    func itemQuantityTextField(textField : UITextField){
        itemQuantityTextField = textField
        itemQuantityTextField.placeholder = "Quantity"
    }
    func compNameTextField(textField : UITextField){
        compNameTextField = textField
        compNameTextField.placeholder = "Compartment Name"
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
        guard !(itemNameTextField.text?.isEmpty)! else {
            return
        }
        guard !(itemQuantityTextField.text?.isEmpty)! else {
            return
        }
        let name = itemNameTextField.text! as String
        let quantity = itemQuantityTextField.text! as String
        
        compTableViewController?.addItem(compId: compId!, name: name, quantity: Int(quantity)!, section : headerId!)
    }
    
    //Handles the toggle gesture
    @objc func selectHeaderView(gesture: UITapGestureRecognizer){
        let cell = gesture.view as! CompartmenViewHeader
        delegate!.toggleSection(header: self, section: cell.headerId!)
    }
    
    //Objective C function to spawn an alert to delete the compartment
    @objc func deleteCompartment(){
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Delete Compartment", message: "Are you sure you want to delete the compartment?", preferredStyle: .alert)
        
        //Initialize the actions
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: self.delete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        compTableViewController?.present(alert, animated : true, completion : nil)
    }
    
    //Actual deletion of compartment via the controller
    func delete(alert: UIAlertAction) {
        compTableViewController?.deleteCompartment(compId: compId!, position: headerId!)
    }
    
    //Objective C function to edit a compartment
    //Spawns an alert box to edit data
    @objc func editCompartment(){
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Edit Compartment", message: "Change the name of the compartment?", preferredStyle: .alert)
        
        //Initialize the actions
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: self.edit)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        
        //Add textfield to the alert to pass string
        alert.addTextField(configurationHandler: compNameTextField)
        
        compTableViewController?.present(alert, animated : true, completion : nil)
    }
    
    func edit(alert: UIAlertAction){
        guard !(compNameTextField.text?.isEmpty)! else{
            return
        }
        let name = compNameTextField.text! as String
        compTableViewController?.editCompartment(compId: compId!, compName: name, position: headerId!);
    }
}

/*
 Important things when creating UI Views programmatically
 
 - Create the views with their correct parameters (title, backgroundcolor, textcolor, resizable, etc.)
 - Add the newly created views as a subview to the parent
 - Set the constraints of the subviews
 (- If you create a button, also create an action that happens when it's clicked)
 */
