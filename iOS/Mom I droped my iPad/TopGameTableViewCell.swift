//
//  TopGameTableViewCell.swift
//  Mom, I dropped my iPad
//
//  Created by Victor Gallego Betorz on 21/2/16.
//  Copyright © 2016 Victor Gallego Betorz. All rights reserved.
//

import UIKit

class TopGameTableViewCell: UITableViewCell {

    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var when: UILabel!
    @IBOutlet weak var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
