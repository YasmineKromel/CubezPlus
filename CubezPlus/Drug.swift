//
//  Drug.swift
//  CubezPlus
//
//  Created by mino on 8/25/18.
//  Copyright © 2018 mino. All rights reserved.
//

import Foundation

class Drug{
    
    var DrugName: String
    var DrugPhotoPath : String
    var DrugPrice: String
    var DrugManufacturer: String
    var DrugDiagnose :String
    var DrugAvailability:Bool
    
    init(name: String , photo_path:String, price:String,manu: String,diagnose:String,availability:Bool) {
        
        DrugName = name
        DrugPhotoPath = photo_path
        DrugPrice = price
        DrugManufacturer = manu
        DrugDiagnose = diagnose
        DrugAvailability = availability
    }
    
}
