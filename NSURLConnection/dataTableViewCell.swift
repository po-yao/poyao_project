//
//  DataTableViewCell.swift
//  NSURLConnection
//
//  Created by Poyao on 2016/9/7.
//  Copyright © 2016年 Poyao. All rights reserved.
//
import UIKit

class DataTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}