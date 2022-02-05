//
//  PokemonCustomTableViewCell.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/05/02.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit

class PokemonCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var form: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
