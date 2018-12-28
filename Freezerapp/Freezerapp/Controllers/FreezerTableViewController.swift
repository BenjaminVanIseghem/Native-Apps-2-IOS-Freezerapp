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

class FreezerTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Firebase reference
    var refFreezers : DatabaseReference!;
    var currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tblFreezers: UITableView!
    
    var freezerList = [FreezerModel]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freezerList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath) as! FreezerTableViewCell
        
        let freezer : FreezerModel
        freezer = freezerList[indexPath.row]
        
        cell.lblName.text = freezer.name
        cell.lblLocation.text = freezer.location
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refFreezers = Database.database().reference()
        
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
                    
                    self.freezerList.append(freezer)
                }
            }
            
            self.tblFreezers.reloadData() 
        })
    }
}
