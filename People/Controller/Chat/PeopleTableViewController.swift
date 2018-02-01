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
    @IBOutlet weak var signOutBt: UIBarButtonItem!
    let roomRef =  Database.database().reference().child("data").child("room")
    private var newRoomRefHandle: DatabaseHandle?
    var channels = DataService.shared.channels
    override func viewDidLoad() {
        super.viewDidLoad()
//        if channels.isEmpty == true  {
//            DataService.shared.getListChat()
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: getListChatNotiKey, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DataService.shared.indexOfPeople = tableView.indexPathForSelectedRow?.row
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
        return channels.count 
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeopleTableViewCell
        cell.userNameLabel.text = channels[indexPath.row].name
        cell.userImage.image = UIImage(named: "user")
    
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let item = channels[indexPath.row]
            roomRef.child(item.id!).removeValue()
            DataService.shared.channels.remove(at: indexPath.row)
            channels = DataService.shared.channels

            self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: UITableViewRowAnimation.automatic)
            self.updateData()

//            roomRef.observe(.childRemoved, with: { (snapshot) -> Void in
//                DataService.shared.channels.remove(at: indexPath.row )
//                
//            })
        default:
            break
        }
    }
    
    
    @objc func updateData() {
        channels = DataService.shared.channels
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let channel = DataService.shared.channels[indexPath.row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    } 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let channel = sender as? Channel {
            let chatVC = segue.destination as! MessageViewController

            chatVC.senderDisplayName = Auth.auth().currentUser?.displayName
            chatVC.channel = channel
            chatVC.channelRef = roomRef.child(channel.id!)
            DataService.shared.channelRef = roomRef.child(channel.id!)
        }
    }
    
    @IBAction func AddMoreChannel(_ sender: UIBarButtonItem) {
        creatAlert()
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        logOut()
    }
    
    deinit {
        removeObserve()
    }
 }
 
 extension PeopleTableViewController {
    func creatAlert() {
        let alert = UIAlertController(title: "Add More", message: "Add More Friend To Chat", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter your friend's name:"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.creatNewChatRoom(roomName: (alert.textFields?.first?.text)!)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func creatNewChatRoom(roomName: String) {
        let newRoomRef =  roomRef.childByAutoId()
        let newRoomData = [ "name": roomName ] as [String : Any]
        newRoomRef.setValue(newRoomData)
        var newRoom: Channel?
        newRoom?.name = roomName
        newRoomRefHandle = roomRef.observe(.childAdded, with: { (snapshot) -> Void in
            let roomData = snapshot.value as! Dictionary<String, AnyObject>
            if (roomData["room_name"] as? String) != nil {
                DataService.shared.channels.append(newRoom!)
                self.tableView.insertRows(at: [IndexPath(row: (DataService.shared.channels.count)-1, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.reloadData()
            } 
        })
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch{
            print("Error while signing out!")
        }
        DataService.shared.channels.removeAll()
        presentToLoginVC()
    }
    
    func presentToLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        AppDelegate.shared.window?.rootViewController = loginViewController
        AppDelegate.shared.window?.makeKeyAndVisible()
        
    }
    
    
    func removeObserve() {
        if let refHandle = DataService.shared.channelRef {
            DataService.shared.roomRef.removeAllObservers()
            refHandle.removeAllObservers()
        }
        roomRef.removeAllObservers()
        NotificationCenter.default.removeObserver(self)
    }
 }
