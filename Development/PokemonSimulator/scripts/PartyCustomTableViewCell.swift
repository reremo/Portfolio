//
//  PartyCustomTableViewCell.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/05/04.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit

class PartyCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var pokemon1: UILabel!
    @IBOutlet weak var pokemon2: UILabel!
    @IBOutlet weak var pokemon3: UILabel!
    @IBOutlet weak var pokemon4: UILabel!
    @IBOutlet weak var pokemon5: UILabel!
    @IBOutlet weak var pokemon6: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
