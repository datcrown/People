//
//  PeopleTableViewCell.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeOfLastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        userImage.image = nil
        userNameLabel.text = ""
        lastMessageLabel.text = ""
        timeOfLastMessageLabel.text = "" 
    }

}
