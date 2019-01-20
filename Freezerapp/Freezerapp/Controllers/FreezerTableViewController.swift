//
//  FreezerTableViewController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//
import UIKit
//import firebase
import FirebaseAuth
import FirebaseDatabase

var currentUserId = Auth.auth().currentUser?.uid

class FreezerTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    //API manager
    let firebaseAPI = FirebaseAPI()
    
    //List where freezers will be stored
    var freezerList = [FreezerModel]()
    
    //TableView UI Component
    @IBOutlet weak var tblFreezers: UITableView!
    
    //Creation of textfields where a new freezer will be added
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
    
    //Override function
    //Here is where the TableView gets stacked
    //It observes the data coming from the firebase database
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Freezers"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        firebaseAPI.getFreezers(){
            freezerList in
            self.freezerList = freezerList
            self.tblFreezers.reloadData()
        }
    }
    
    //Get the size of the freezerlist
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freezerList.count
    }
    
    //Get the data for each cell and initialize the labels inside the cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath) as! FreezerTableViewCell
        
        let freezer : FreezerModel
        freezer = freezerList[indexPath.row]
        
        cell.textLabel?.text = freezer.name
        cell.detailTextLabel?.text = freezer.location
        
        return cell
    }
    
    //Action what happens when the navbar button is pressed
    //Add a new freezer
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Initialize alert to spawn
        let alert = UIAlertController(title: "Add your freezer", message: "Add your freezer", preferredStyle: .alert)
        
        //Initialize the actions
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add the actions to the alert
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        //Add textfields to the alert to pass strings
        alert.addTextField(configurationHandler: freezerNameTextField)
        alert.addTextField(configurationHandler: freezerLocationTextField)
        
        self.present(alert, animated : true, completion : nil)
        
    }
    
    //Save method which is used inside the alert
    func save(alert : UIAlertAction){
        //Get the values from the text fields
        let name = freezerNameTextField.text! as String
        let location = freezerLocationTextField.text! as String
        
        //Call API
        firebaseAPI.uploadFreezer(name: name, location: location)
        
        //Reload the View
        self.tblFreezers.reloadData()
        
    }
    
    //Adds functionality to editing style
    //If user swipes the cell, he/she can then choose to delete the object
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let f = freezerList[indexPath.row]
            firebaseAPI.deleteFreezer(f: f)
            firebaseAPI.deleteAllItemsOfFreezer(freezerId: f.id!)
        }
        
        self.tblFreezers.reloadData()
    }
    
    //Prepare the segue with the freezerdata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = sender as? Int
        
        //Pass data through NavigationController to the Detail View
        if segue.identifier == "toCompartmentController"  {
            if let controller = segue.destination as? CompartmentDetailController {
                controller.freezer = freezerList[selectedRow!]
                
            }
        }
    }
    
    //When cell is clicked, load the detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCompartmentController", sender: indexPath.row)
    }
    
}
