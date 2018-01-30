//
//  MessageTableViewCell.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
//    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var senderNameLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
class SentCell: MessageTableViewCell {
    override func prepareForReuse() {
        messageText.text = nil
    }
}

class ReciveCell: MessageTableViewCell {
    override func prepareForReuse() {
        messageText.text = nil
    }
    
}
