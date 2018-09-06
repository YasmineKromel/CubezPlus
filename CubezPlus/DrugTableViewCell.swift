//
//  DrugTableViewCell.swift
//  CubezPlus
//
//  Created by mino on 8/28/18.
//  Copyright © 2018 mino. All rights reserved.
//

import UIKit

class DrugTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var PhotoOfDrug: UIImageView!
    
    @IBOutlet weak var DrugTitle: UILabel!
    
    @IBOutlet weak var DrugPrice: UILabel!
    
    @IBOutlet weak var DrugCurrency: UILabel!
    
    @IBOutlet weak var IsStocked: UILabel!
    
    @IBOutlet weak var BuyNowBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
