//
//  FreezerModel.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

class FreezerModel{
    var id : String?
    var name : String?
    var location : String?
    var compartments : [CompartmentModel]?
    
    init(id : String?,
         name: String?,
         location: String?) {
        self.id = id;
        self.name = name;
        self.location = location;
    }
    
    init(id : String?,
         name: String?,
         location : String?,
         compartments : [CompartmentModel]?){
        self.id = id
        self.name = name
        self.location = location
        self.compartments = compartments
    }
}
