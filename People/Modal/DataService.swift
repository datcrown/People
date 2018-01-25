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
import CodableFirebase

let getListChatNotiKey = Notification.Name.init("getListChat")
let getAvaImageNotiKey = Notification.Name.init("downloadImage")
let getChatHistoryNotiKey = Notification.Name.init("getHistoryChat")
class DataService {
    static let shared: DataService = DataService()
    var indexOfPeopleAtTBV: Int?
    var indexOfPeople: Int?
    var ref: DatabaseReference?
    var refHandle:  UInt!

    private var _data: data1?
    var data: data1? {
        get {
            if _data == nil {
            }
            return _data
        } set {
            _data = newValue
        }
    }
    
    func getListChat() {
       requestApi()
    }
    

    func getChatHistory()  {
        requestApi()
    }
    
    
    func requestApi() {
        let data = try! FirebaseEncoder().encode(_data)

       // Database.database().reference().child("data").setValue(data)
        Database.database().reference().child("data").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                self._data = try FirebaseDecoder().decode(data1.self, from: value)
                debugPrint(self._data)
                NotificationCenter.default.post(name: getListChatNotiKey, object: nil )
                NotificationCenter.default.post(name: getChatHistoryNotiKey, object: nil )

            } catch let error {
                print(error)
            }
        })
        
//        let urlString = "https://fir-training-9ffe9.firebaseio.com"
//        guard let url = URL(string: urlString) else { return }
//        let requestURL = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
//            guard error == nil else { return }
//            guard data != nil else { return }
//            DispatchQueue.main.async {
//                self._listChat = try? JSONDecoder().decode(ListChat.self, from: data!)
//            }
//        }
//        task.resume()

        
        
        //        Alamofire.request("https://fir-training-9ffe9.firebaseio.com", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodableObject{ (response: DataResponse<T>)  in
        //
        //            switch response.result {
        //            case .success(_) :
        //
        //                success(response)
        //
        //
        //            case .failure(let error):
        //                print(error)
        //                break
        //            }
        //        }
    }
    func getImage(from img_ID: String) -> String {
        let baseUrl = "http://202.32.203.168:9117/api=load_img"
        var urlString = baseUrl
        var parameters: Dictionary<String, String> = [:]
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
