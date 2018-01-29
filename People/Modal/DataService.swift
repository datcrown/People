//
//  DataService.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//
import Foundation
import Alamofire
import CodableAlamofire
import Firebase

let getListChatNotiKey = Notification.Name.init("getListChat")
let getAvaImageNotiKey = Notification.Name.init("downloadImage")
let getChatHistoryNotiKey = Notification.Name.init("getHistoryChat")
class DataService {
    static let shared: DataService = DataService()
    let roomRef =  Database.database().reference().child("data").child("room")
    private lazy var messageRef: DatabaseReference = roomRef.child("message")
    var indexOfPeopleAtTBV: Int?
    var indexOfPeople: Int?
    var channelRef: DatabaseReference?
    var refHandle:  UInt!
     var newMessageRefHandle: DatabaseHandle?
     var updatedMessageRefHandle: DatabaseHandle?
    
    
    private var channelRefHandle: DatabaseHandle?
    private var _channels: [Channel] = []
    var channels: [Channel] {
        get {
            return _channels
        } set {
            _channels = newValue
        }
    }
    
    private var _messages: [Message] = []
    var messages: [Message] {
        get {
            return _messages
        } set {
            _messages = newValue
        }
    }
    
    
    func getListChat() {
        channelRefHandle = roomRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String! {
                let message = channelData["message"]
                self.channels.append(Channel(id: id, name: name, message: message as? Message))
                NotificationCenter.default.post(name: getListChatNotiKey, object: nil)
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    
    func getChatHistory()  {
        self._messages.removeAll()
        messageRef = channelRef!.child("message")
        let messageQuery = messageRef.queryLimited(toLast:25)
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String! {
                self._messages.append(Message(senderID: id, senderName: name, content: text))
                NotificationCenter.default.post(name: getChatHistoryNotiKey, object: nil)
            }
        })
        
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>
     
            
        })
    }

    
}
