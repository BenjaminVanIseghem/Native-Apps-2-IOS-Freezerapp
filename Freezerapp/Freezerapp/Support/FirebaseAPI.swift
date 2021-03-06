//
//  FirebaseAPI.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 30/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import Firebase

//This class will be used to connect with firebase
class FirebaseAPI {
    
    var currentUserId = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    //Get list of Freezers with "closure" statement that passes the model when finished
    func getFreezers(completion: @escaping ([FreezerModel]) -> Void){
        var freezerList = [FreezerModel]()
        
        //Observer the firebase data
        ref.child("freezers").child(currentUserId!).observe(DataEventType.value, with: {
            (snapshot) in
            if snapshot.childrenCount > 0 {
                freezerList.removeAll()
                
                for freezers in snapshot.children.allObjects as! [DataSnapshot]{
                    let freezerObject = freezers.value as? [String : AnyObject]
                    
                    let freezerId = freezerObject?["id"]
                    let freezerName = freezerObject?["name"]
                    let freezerLocation = freezerObject?["location"]
                    
                    let freezer = FreezerModel(id: freezerId as? String, name: freezerName as? String, location: freezerLocation as? String)
                    
                    //append object to the list
                    freezerList.append(freezer)
                }
            }
            completion(freezerList)
        })
    }
    
    //Save Freezers to Firebase Database
    func uploadFreezer(name : String, location : String){
        //Sets the correct ref
        let ref = self.ref.child("freezers").child(currentUserId!).childByAutoId()
        let id = ref.key
        
        //Make freezer object to store
        let freezer = [
            "id": id! as String,
            "name": name,
            "location": location
            ]
        
        //Add the data to the Firebase Database
        ref.setValue(freezer)
    }
    
    //Remove a Freezer from Firebase Database
    func deleteFreezer(f : FreezerModel){
        ref.child("freezers").child(currentUserId!).child(f.id!).removeValue()
    }
    
    //Get compartments from a freezer
    func getCompartments(id : String, completion: @escaping ([CompartmentModel]) -> Void){
        let refComp = ref.child("compartments").child(currentUserId!).child(id)
        
        //initialize array of compartments to fill and return
        var compList = [CompartmentModel]()
        
        refComp.observe(DataEventType.value, with: {(snapshot) in
            //empty the compartment array
            compList.removeAll()
            //iterate the snapshot
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                //Convert to NSDictionary
                let info = item.value as! NSDictionary
                
                //Convert all values to strings and put them inside a CompartmentModel
                let id = info.value(forKey: "id")
                let name = info.value(forKey: "name")
                let comp = CompartmentModel(id: id as? String, name: name as? String)
                
                //Append compartment to array
                compList.append(comp)
            }
            completion(compList)
        })
    }
    
    //Add a compartment
    func uploadCompartment(freezerId : String, name : String){
        //Sets the correct ref
        let ref = self.ref.child("compartments").child(currentUserId!).child(freezerId).childByAutoId()
        let id = ref.key
        
        //Make Compartment object to store
        let compartment = [
            "id": id! as String,
            "name": name
        ]
        
        //Add the data to the Firebase Database
        ref.setValue(compartment)
    }
    
    //Delete a compartment
    func deleteCompartment(freezerId : String, c : String){
        ref.child("compartments").child(currentUserId!).child(freezerId).child(c).removeValue()
    }
    
    //Delete all compartments of a Freezer
    func deleteAllCompartmentsOfFreezer(freezerId: String){
        ref.child("compartments").child(currentUserId!).child(freezerId).removeValue()
    }
    
    //Get items from compartment
    func getItems(id : String, completion: @escaping ([ItemModel]) -> Void){
        let refItem = ref.child("items").child(currentUserId!).child(id)
        
        //initialize empty array of items to fill and return
        var itemList = [ItemModel]()
        
        refItem.observe(DataEventType.value, with: {(snapshot) in
            //empty the item array
            itemList.removeAll()
            //Iterate snapshot
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                //Convert to NSDictionary
                let info = item.value as! NSDictionary
                
                //Convert all values to strings and put them inside a CompartmentModel
                let id = info.value(forKey: "id") as? String
                let name = info.value(forKey: "name") as? String
                let quantity = info.value(forKey: "quantity") as? String
                
                let item = ItemModel(id: id, name: name, quantity: Int(quantity!))
                
                //Append Item to array
                itemList.append(item)
            }
            completion(itemList)
        })
    }
    
    
    //Add an item
    func uploadItem(compId : String, name : String, quantity : Int){
        //Sets the correct ref
        let ref = self.ref.child("items").child(currentUserId!).child(compId).childByAutoId()
        let id = ref.key
        
        //Make Item object to store
        let item = [
            "id" : id! as String,
            "name" : name,
            "quantity" : String(quantity)
            ]
        
        //Add the data to the Firebase Database
        ref.setValue(item)
    }
    
    //Delete an item
    func deleteItem(compId : String, i : ItemModel){
        ref.child("items").child(currentUserId!).child(compId).child(i.id!).removeValue()
    }
    
    //Delete all items of a compartment
    func deleteAllItemsOfCompartment(compId : String){
        ref.child("items").child(currentUserId!).child(compId).removeValue()
    }
    
    //Delete all items of a freezer
    func deleteAllItemsOfFreezer(freezerId : String){
        var compIdList = [String]()
        
        //Check all compartments of freezer and add their id to an array
        ref.child("compartments").child(currentUserId!).child(freezerId)
            .observeSingleEvent(of: DataEventType.value, with:{
            (snapshot) in
                for item in snapshot.children.allObjects as! [DataSnapshot]{
                    //Convert to NSDictionary
                    let info = item.value as! NSDictionary
                    let id  = info["id"] as! String
                    compIdList.append(id)
                    self.ref.child("compartments").child(self.currentUserId!).child(freezerId).child(id).removeValue()
                }
                
                //go through array of id's of compartments and delete all their items
                for id in compIdList{
                    self.deleteAllItemsOfCompartment(compId: id)
                }
        })
    }
    
    //Edit a compartment name in the firebase database
    func editCompartment(freezerId: String, compId: String, compName: String){
        ref.child("compartments").child(currentUserId!).child(freezerId).child(compId)
            .updateChildValues(["name": compName])
    }
    //Edit a freezer name in the firebase database
    func editFreezer(freezerId: String, freezerName: String, freezerLocation: String){
        ref.child("freezers").child(currentUserId!).child(freezerId)
            .updateChildValues(["name": freezerName, "location": freezerLocation])
    }
    //Edit a item name in the firebase database
    func editItemName(compId: String, itemId: String, itemName: String){
        ref.child("items").child(currentUserId!).child(compId).child(itemId)
            .updateChildValues(["name": itemName])
    }

    //Edit quantity from item
    func editItemQuantity(compId: String, itemId: String, itemQuantity: String){
        ref.child("items").child(currentUserId!).child(compId).child(itemId)
            .updateChildValues(["quantity": itemQuantity])
    }
}
