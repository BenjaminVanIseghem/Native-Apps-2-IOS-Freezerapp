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
    //Firebase reference
    var refFreezers = Database.database().reference()
    
    var freezerList = [FreezerModel]()
    
    //TableView UI Component
    @IBOutlet weak var tblFreezers: UITableView!
    
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
        //Sets the correct ref
        let ref = refFreezers.child("freezers").child(currentUserId!).childByAutoId()
        let id = ref.key
        
        //Make freezer object to store
        let freezer = [
            "id": id! as NSString,
            "name": freezerNameTextField.text! as NSString,
            "location": freezerLocationTextField.text! as NSString
            ] as [String : Any]
        
        //Add the data to the Firebase Database
        ref.setValue(freezer)
        
        //Reload the View
        self.tblFreezers.reloadData()
        
    }
    
    //Override function
    //Here is where the TableView gets stacked
    //It observes the data coming from the firebase database
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Observer the firebase data
        refFreezers.child("freezers").child(currentUserId!).observe(DataEventType.value, with: {
            (snapshot) in
            if snapshot.childrenCount > 0 {
                self.freezerList.removeAll()
                
                for freezers in snapshot.children.allObjects as! [DataSnapshot]{
                    let freezerObject = freezers.value as? [String : AnyObject]
                    
                    let freezerId = freezerObject?["id"]
                    let freezerName = freezerObject?["name"]
                    let freezerLocation = freezerObject?["location"]
                    
                    let freezer = FreezerModel(id: freezerId as? String, name: freezerName as? String, location: freezerLocation as? String)
                    
                    //append object to the list
                    self.freezerList.append(freezer)
                }
            }
            
            //reload data for changes to take effect
            self.tblFreezers.reloadData() 
        })
    }
    
    //Adds functionality to editing style
    //If user swipes the cell, he/she can then choose to delete the object
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let f = freezerList[indexPath.row]
            refFreezers.child("freezers").child(currentUserId!).child(f.id!).removeValue()
        }
        
        self.tblFreezers.reloadData()
    }
    
    //Prepare the segue with the freezerdata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CompartmentSwipingController
        let selectedRow = sender as? Int
    
        destination.freezer = freezerList[selectedRow!]
    }
    
    //When cell is clicked, load the detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCompartmentCollectionView", sender: indexPath.row)
    }
    
}
