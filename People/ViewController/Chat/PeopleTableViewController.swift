 //
//  PeopleTableViewController.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import UIKit
import Kingfisher

class PeopleTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        DataService.shared.getListChat()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: getListChatNotiKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: getAvaImageNotiKey, object: nil)
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
        return (DataService.shared.listChat?.data.count) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeopleTableViewCell
        let data = DataService.shared.listChat?.data[indexPath.row]
        cell.userNameLabel.text = data?.frd_name
        cell.lastMessageLabel.text = data?.last_msg
        cell.timeOfLastMessageLabel.text = DataService.shared.convertDateToString(time_stamp: (data?.sent_time)!)
        if let avaId = data?.ava_id {
    //       let url =  DataService.shared.getURL(from: avaId)
      //      cell.userImage.kf.setImage(with: URL(string: url))
        } else {
            cell.userImage.image = UIImage(named: "user")
        }
        
        return cell
    }
   
    
    @objc func updateData() {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.shared.indexOfPeople = tableView.indexPathForSelectedRow?.row
        DataService.shared.frd_idAtIndexOfPeopleAtTBV = DataService.shared.listChat?.data[indexPath.row].frd_id
    }
    
}
