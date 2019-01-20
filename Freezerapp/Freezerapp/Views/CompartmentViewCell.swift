//
//  CompartmentViewCell.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 31/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

class CompartmentViewCell: UITableViewCell{
    //Parameters initialized in the controller
    var compTableViewController : CompartmentDetailController?
    var section : Int?
    var row : Int?
    var compId : String?
    var itemId : String?
    var itemQuantity : String?
    
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    //Create label for item quantity
    let quantityLabel: UILabel = {
        let label = UILabel()
        //set paramaters for label
        label.text = "Quantity"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    //Create button to add one to quantity
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "add_50")
        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    //Create button to substract one from quantity
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "minus_50")
        //Make sure the button resizes according to the constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    //Create button to edit the item
    let editItemButton: UIButton = {
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
    
    //Set up the view, add the subviews and constraints
    func setUpView(){
        addSubview(nameLabel)
        addSubview(quantityLabel)
        addSubview(addButton)
        addSubview(minusButton)
        addSubview(editItemButton)
        
        //Button functionality
        editItemButton.addTarget(self, action: #selector(CompartmentViewCell.editItemName), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(CompartmentViewCell.minusOne), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(CompartmentViewCell.plusOne), for: .touchUpInside)
        
        //Horizontal constraints
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v1]-16-[v3(24)]-[v0(24)]-[v2(24)]-16-[v4(24)]-16-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": quantityLabel, "v1": nameLabel, "v2": addButton, "v3": minusButton, "v4": editItemButton]))
        //Vertical constraints
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": quantityLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": addButton]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": minusButton]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": editItemButton]))
    }
    
    //Text field inside the alert that is called by the edit button
    var itemNameTextField : UITextField!
    func itemNameTextField(textField : UITextField!){
        itemNameTextField = textField
        itemNameTextField.placeholder = "Item name"
    }
    
    //Objective C function to edit an item name
    //Spawns an alert box to edit data
    @objc func editItemName(){
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Edit Item", message: "Change the name of the item?", preferredStyle: .alert)
        
        //Initialize the actions
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: self.edit)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        
        //Add textfield to the alert to pass string
        alert.addTextField(configurationHandler: itemNameTextField)
        
        compTableViewController?.present(alert, animated : true, completion : nil)
    }
    //Edit item name
    func edit(alert: UIAlertAction){
        guard !itemNameTextField.text!.isEmpty else {
            return
        }
        let name = itemNameTextField.text! as String
        
        compTableViewController?.editItemName(
            compId: compId!,
            itemId: itemId!,
            itemName: name,
            section: section!,
            row: row!
        )
    }
    //Add one to item quantity
    @objc func plusOne(){
        compTableViewController?
            .itemPlusOne(
                compId: compId!,
                itemId: itemId!,
                itemQuantity: itemQuantity!,
                section: section!,
                row: row!
        )
    }
    //Substract one from item quantity
    @objc func minusOne(){
        compTableViewController?
            .itemMinusOne(
                compId: compId!,
                itemId: itemId!,
                itemQuantity: itemQuantity!,
                section: section!,
                row: row!
        )
    }
}
