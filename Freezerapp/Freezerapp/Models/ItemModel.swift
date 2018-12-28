//
//  ItemModel.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

class ItemModel{
    var id : String?
    var name : String?
    var quantity : Int?
    
    init(id : String?,
         name: String?,
         quantity: Int?) {
        self.id = id;
        self.name = name;
        self.quantity = quantity;
    }
}
