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
    
    //Set up the view, add the subviews and constraints
    func setUpView(){
        addSubview(nameLabel)
        addSubview(quantityLabel)
//        addConstraints(NSLayoutConstraint.constraints(
//            withVisualFormat: "H:|-16-[v0]|",
//            options: NSLayoutConstraint.FormatOptions(),
//            metrics: nil,
//            views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v1]-[v0]-16-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": quantityLabel, "v1": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["v0": quantityLabel]))
    }
}
