//
//  CompartmentCollectionViewCell.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 29/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit

class CompartmentCollectionViewCell : UICollectionViewCell {
    
    var test = nil
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
