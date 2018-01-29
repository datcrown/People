//
//  Modal.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import Foundation
struct data1: Codable {
    var channel: Channel
}

struct Channel: Codable {
    let id: String?
    var name: String?
    var message: Message?
}
struct Message: Codable {
    var senderID: String?
    var senderName: String?
    var content: String?
}

