//
//  DrugModel.swift
//  CubezPlus
//
//  Created by mino on 8/28/18.
//  Copyright © 2018 mino. All rights reserved.
//

import Foundation

class DrugModel {
    
    var ID :String
    var DName:String
    var DPhotoPath : String
    var DPrice: String
    var DManu :String
    var DDiagnose :String
    var DAvailablity : String
    
    init(id:String,name:String ,photo:String,price:String,manu:String , diag: String,avail :String) {
    
        self.DName = name
        self.DPhotoPath = photo
        self.DPrice = price
        self.DManu = manu
        self.DDiagnose = diag
        self.DAvailablity = avail
        self.ID = id
    }
    
}
