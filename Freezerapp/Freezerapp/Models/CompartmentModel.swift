//
//  CompartmentModel.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

class CompartmentModel{
    var id : String?
    var name : String?
    var items : [ItemModel]?
    
    init(id : String?,
         name: String?) {
        self.id = id;
        self.name = name;
    }
    
    init(id : String?,
         name: String?,
         items : [ItemModel]?){
        self.id = id
        self.name = name
        self.items = items
    }
}
