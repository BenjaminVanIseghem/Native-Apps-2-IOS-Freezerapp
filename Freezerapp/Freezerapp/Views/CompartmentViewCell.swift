//
//  CompartmentViewCell.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 31/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

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
        //Horizontal constraints
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v1]-16-[v3(24)]-[v0]-[v2(24)]-16-[v4(24)]-16-|",
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
}
