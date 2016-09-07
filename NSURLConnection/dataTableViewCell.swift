//
//  dataTableViewCell.swift
//  NSURLConnection
//
//  Created by Poyao on 2016/9/6.
//  Copyright © 2016年 Poyao. All rights reserved.
//

import UIKit

class dataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardID: UILabel!
    @IBOutlet weak var cardName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
