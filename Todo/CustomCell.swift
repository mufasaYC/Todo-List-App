//
//  CustomCell.swift
//  Todo
//
//  Created by Mustafa Yusuf on 25/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

	@IBOutlet weak var backView: UIView!
	@IBOutlet weak var listLabel: UILabel!
	@IBOutlet weak var completionLabel: UILabel!
	
	@IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
