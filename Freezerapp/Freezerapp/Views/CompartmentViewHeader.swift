//
//  CompartmentViewHeader.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 31/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
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
    
    @objc func selectHeaderView(gesture: UITapGestureRecognizer){
        let cell = gesture.view as! CompartmenViewHeader
        delegate!.toggleSection(header: self, section: cell.headerId!)
    }
}
