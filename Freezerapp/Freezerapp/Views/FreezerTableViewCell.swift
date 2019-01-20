//
//  FreezerTableViewCell.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

class FreezerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    var controller: FreezerTableViewController?
    var id : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Creation of textfields for editing freezer
    var freezerNameTextField : UITextField!
    var freezerLocationTextField : UITextField!
    
    //Functions where textfield will be assigned
    func freezerNameTextField(textField : UITextField!){
        freezerNameTextField = textField
        freezerNameTextField.placeholder = "Freezer name"
    }
    func freezerLocationTextField(textField : UITextField){
        freezerLocationTextField = textField
        freezerLocationTextField.placeholder = "Location"
    }
    //Action when edit button is pressed
    @IBAction func editFreezer(_ sender: UIButton) {
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Edit your freezer", message: "Please fill in both fields", preferredStyle: .alert)

        //Initialize the actions
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: self.edit)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        //Add the actions to the alert
        alert.addAction(editAction)
        alert.addAction(cancelAction)

        //Add textfields to the alert to pass strings
        alert.addTextField(configurationHandler: freezerNameTextField)
        alert.addTextField(configurationHandler: freezerLocationTextField)

        controller?.present(alert, animated : true, completion : nil)
    }
    
    func edit(alert: UIAlertAction){
        guard !freezerLocationTextField.text!.isEmpty else {
            return
        }
        guard !freezerNameTextField.text!.isEmpty else {
            return
        }
        //Get the values from the text fields
        let name = freezerNameTextField.text! as String
        let location = freezerLocationTextField.text! as String
        
        controller?.editFreezer(freezerId: id!, freezerName: name, freezerLocation: location)
    }
}
