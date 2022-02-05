//
//  WeaponCustomTableViewCell.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/05/01.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit

class WeaponCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var weaponType: UILabel!
    @IBOutlet weak var weaponPower: UILabel!
    @IBOutlet weak var weaponRate: UILabel!
    @IBOutlet weak var weaponNature: UILabel!
    @IBOutlet weak var weaponScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

