 //
 //  PeopleTableViewController.swift
 //  People
 //
 //  Created by Quoc Dat on 12/12/17.
 //  Copyright © 2017 Quoc Dat. All rights reserved.
 //
 
 import UIKit
 import Kingfisher
 import Firebase
 class PeopleTableViewController: UITableViewController {
    
    let roomRef =  Database.database().reference().child("data").child("room")
    private var newRoomRefHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigatvar bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //      DataService.shared.getListChat()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: getListChatNotiKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: getAvaImageNotiKey, object: nil)
    }
     func observeRoom() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (DataService.shared.data?.room.count) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeopleTableViewCell
        let data = DataService.shared.data?.room[indexPath.row]
        cell.userNameLabel.text = data?.frd_name
        guard let last_msg = data?.last_msg else { fatalError() }
        cell.lastMessageLabel.text = data?.last_msg
        cell.timeOfLastMessageLabel.text = DataService.shared.convertDateToString(time_stamp: (data?.sent_time)!)
        if let avaId = data?.ava_id {
            //        let url =  DataService.shared.getURL(from: avaId)
            //        cell.userImage.kf.setImage(with: URL(string: url))
        } else {
            cell.userImage.image = UIImage(named: "user")
        }
        
        return cell
    }
    
    
    @objc func updateData() {
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        DataService.shared.indexOfPeople = tableView.indexPathForSelectedRow?.row
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("wfrwq")
        DataService.shared.indexOfPeople = tableView.indexPathForSelectedRow?.row
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func AddMoreChannel(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add More", message: "Add More Friend To Chat", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter your friend's name:"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            //            if let roomName = alert.textFields?.first {
            //                let newChannelRef =  Database.database().reference().child("data").childByAutoId()
            //                let channelItem = [
            //                    "room_name": roomName
            //                ]
            //                newChannelRef.setValue(channelItem)
            //            }
            self.creatNewChatRoom(roomName: (alert.textFields?.first?.text)!)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func creatNewChatRoom(roomName: String) {

        let newRoomRef =  roomRef.childByAutoId()
        let newBookId = newRoomRef.key
        let newRoomData = [
            "room_name": roomName,
            "frd_id":"57a46016e4b00ecad966301a",
            "is_online":false,
            "message":[],
            "last_msg":"",
            "sent_time":"",
            "last_login":"",
            "frd_name": roomName,
            "ava_id":"",
            "msg_id":"",
            "is_own":true,
            "gender":0
            
            ] as [String : Any]
    newRoomRef.setValue(newRoomData)
        var newRoom: Room?
        newRoom?.room_name = roomName
        newRoomRefHandle = roomRef.observe(.childAdded, with: { (snapshot) -> Void in
            let roomData = snapshot.value as! Dictionary<String, String>
            if let roomName = roomData["room_name"] as String! {
            DataService.shared.data?.room.append(newRoom)
                self.tableView.insertRows(at: [IndexPath(row: (DataService.shared.data?.room.count)!-1, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode message data")
            }
        })

        
    }

 }
