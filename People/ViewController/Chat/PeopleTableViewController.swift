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
    enum Section: Int {
        case createNewChannelSection = 0
        case currentChannelsSection
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigatvar bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        return (DataService.shared.channels.count) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeopleTableViewCell
        let data = DataService.shared.channels[indexPath.row]
        cell.userNameLabel.text = data.name
        cell.userImage.image = UIImage(named: "user")
    
        return cell
    }
    
    
    @objc func updateData() {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DataService.shared.indexOfPeople = tableView.indexPathForSelectedRow?.row
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let channel = DataService.shared.channels[indexPath.row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let channel = sender as? Channel {
            let chatVc = segue.destination as! MessageViewController
            
            chatVc.senderDisplayName = Auth.auth().currentUser?.displayName
            chatVc.channel = channel
            chatVc.channelRef = roomRef.child(channel.id!)
            DataService.shared.channelRef = roomRef.child(channel.id!)
        }
    }
    
    @IBAction func AddMoreChannel(_ sender: UIBarButtonItem) {
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
        let newBookId = newRoomRef.key
        let newRoomData = [
            "name": roomName
            ] as [String : Any]
        newRoomRef.setValue(newRoomData)
        var newRoom: Channel?
        newRoom?.name = roomName
        newRoomRefHandle = roomRef.observe(.childAdded, with: { (snapshot) -> Void in
            let roomData = snapshot.value as! Dictionary<String, AnyObject>
            if let roomName = roomData["room_name"] as! String! {
                DataService.shared.channels.append(newRoom!)
                self.tableView.insertRows(at: [IndexPath(row: (DataService.shared.channels.count)-1, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
           try Auth.auth().signOut()
        } catch{
            print("Error while signing out!")
        }
        DataService.shared.channels.removeAll()
        DataService.shared.messages.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(controller, animated: true, completion: nil)

    }
    
 }
