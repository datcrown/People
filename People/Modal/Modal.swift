//
//  Modal.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import Foundation


struct Data1: Codable {
    let frd_id: String?
    let is_online: Bool?
    let video_call_waiting: Bool?
    let unread_num: Int?
    let last_msg: String?
    let msg_type: String?
    let sent_time: String?
    let voice_call_waiting: Bool?
    let long: Float?
    let last_login: String?
    let frd_name: String?
    let ava_id: String?
    let msg_id: String?
    let is_own: Bool?
    let gender: Int?
    let lat: Float?
    let dist: Int?
    let content: String?
    let time_stamp: String?
    let token:  String?
}
struct ListChat: Codable {
    let data:  [Data1]
}
struct ChatHistory: Codable {
     let data:  [Data1]
}
struct Token: Codable {
    let data: Data1
}
