//
//  CompartmentSwipingController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 29/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit
import Firebase

class CompartmentSwipingController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var freezer : FreezerModel?
    var compartments : [CompartmentModel]? = []
    var ref = Database.database().reference()
    
    var labelsArr : [String] = []
    
    //When the view loads, the cell are registered and paging is being enabled
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        getCompartments(freezerId: (freezer?.id)!)

        collectionView?.backgroundColor = .white
        collectionView?.register(CompartmentCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.isPagingEnabled = true
    }
    
    
    //override the minimum line spacing
    //This is the spacing between the collections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Returns the amount of collections
    //This is calculated with the amount of compartments inside a freezer
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if compartments == nil{
            return 4
        }
        return (compartments?.count)!
    }
    
    //Returns the standard cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CompartmentCollectionViewCell
        
        
        
        return cell
    }
    
    //Sets the size of each collection to the width and height of the frame
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    //API call to the firebase database to fetch the current compartments
    func getCompartments(freezerId : String){
        let refComp  = ref.child("compartments").child(currentUserId!).child(freezerId)
        refComp.observe(DataEventType.value, with: {(snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                //Convert to NSDictionary
                let info = item.value as! NSDictionary
                
                //Convert all values to strings and put them inside a CompartmentModel
                let id = info.value(forKey: "id")
                let name = info.value(forKey: "name")
                let comp = CompartmentModel(id: id as? String, name: name as? String)
                
                //Append compartment to array
                self.compartments?.append(comp)
                self.labelsArr.append(name as! String)
            }
            self.collectionView.reloadData()
        })
    }
}
