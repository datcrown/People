//
//  Modal.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import Foundation
struct data1: Codable {
    var room: [Room?]
}

struct Room: Codable {
    var room_name: String?
    let frd_id: String?
    let is_online: Bool?
    let message: [Message]?
    let last_msg: String?
    let sent_time: String?
    let last_login: String?
    let frd_name: String?
    let ava_id: String?
    let msg_id: String?
    let is_own: Bool?
    let gender: Int?

}

struct Message: Codable {
    let content: String?
    let msg_type: String?
    let is_own: Bool
    let msg_id: String
    let time_stamp: String
}
struct ListChat: Codable {
    let data:  [Room?]
}
struct ChatHistory: Codable {
     let data:  [Room?]
}

