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
let getListChatNotiKey = Notification.Name.init("getListChat")
let getAvaImageNotiKey = Notification.Name.init("downloadImage")
let getChatHistoryNotiKey = Notification.Name.init("getHistoryChat")
let token = "5c5a1c9b-3db0-4e5f-99cc-37333821a05e"
class DataService {
    static let shared: DataService = DataService()
    var frd_idAtIndexOfPeopleAtTBV: String?
    var indexOfPeople: Int?
    
    // MARK: - Get Token
    private var _token: Token?
    
    
    
    // MARK: - Get List Chat
    private var _listChat: ListChat?
    var listChat: ListChat? {
        get {
            if _listChat == nil {
            }
            return _listChat
        } set {
            _listChat = newValue
        }
    }
    
    func getListChat() {
        let parameters: Parameters = ["api":"list_conversation",
                                      "time_stamp":"",
                                      "take":24,
                                      "token":"\(token)"
        ]
        requestApi(parameters: parameters, customClass: self._listChat) { (data) in
            self._listChat = data.result.value as? ListChat
            NotificationCenter.default.post(name: getListChatNotiKey, object: nil )
        }
        
        
    }
    
    // MARK: - Get Chat History
    private var _chatHistory: ChatHistory?
    var chatHistory: ChatHistory? {
        get {
            if _chatHistory == nil {
            }
            return _chatHistory
        } set {
            _chatHistory = newValue
        }
    }
    func getChatHistory(from frd_id: String)  {
        
        let parameters: Parameters = [  "api":"add_cmt_version_2",
                                        "buzz_id":"5a0d57c1e4b074e3adf224ea",
                                        "cmt_val":"SBX",
                                        "token":"4d964c7c-e5a3-4919-b17a-7243464d5007"
        ]
       
        requestApi(parameters: parameters, customClass: self._chatHistory) { (data) in
            self._chatHistory = data.result.value as? ChatHistory
            NotificationCenter.default.post(name: getChatHistoryNotiKey, object: nil )
        }
        
        
    }
    
    
    func requestApi<T:Codable> (parameters: Parameters?, customClass:T, success: @escaping (DataResponse<T>) -> Void) {
        
        Alamofire.request("http://202.32.203.168:9119", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodableObject{ (response: DataResponse<T>)  in
            
            switch response.result {
            case .success(_) :
                
                success(response)
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    func getImage(from img_ID: String) -> String {
        let baseUrl = "http://202.32.203.168:9117/api=load_img"
        var urlString = baseUrl
        var parameters: Dictionary<String, String> = [:]
        parameters["token"] = "\(token)"
        parameters["img_id"] = "\(img_ID)"
        parameters["img_kind"] = "1"
        for (key,value) in parameters {
            urlString += "&" + key + "=" + value
        }
        return urlString
    }
    func localDate(fromGlobalTime dateString: String, inFormat format: String) -> Date? {
        if (dateString.characters.count ) > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            let usLocale = Locale(identifier: "en_US")
            formatter.locale = usLocale
            formatter.timeZone = TimeZone(identifier: "GMT")
            return formatter.date(from: dateString)
        }
        else {
            return nil
        }
    }
    func convertDateToString(time_stamp: String) -> String {
        let date = localDate(fromGlobalTime: time_stamp, inFormat: "yyyyMMddHHmmssSSS")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        dateFormatter.locale = Locale(identifier: "EN" )
        return dateFormatter.string(from: date!)
    }
}
