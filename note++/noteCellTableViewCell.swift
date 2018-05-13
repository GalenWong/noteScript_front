//
//  noteCellTableViewCell.swift
//  note++
//
//  Created by galenw on 28/3/2018.
//  Copyright © 2018 galenw. All rights reserved.
//

import UIKit
import CoreData

class noteCellTableViewCell: UITableViewCell {

    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!

    var objID: NSManagedObjectID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
