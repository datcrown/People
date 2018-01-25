//
//  MessageViewController.swift
//  People
//
//  Created by Quoc Dat on 12/12/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController,UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var numberPeople: Int? = 0

    @IBOutlet var sendMessageBT: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomOfMessageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTableView: UITableView!
    var chatHistory = DataService.shared.data?.room[DataService.shared.indexOfPeople!]?.message

    override func viewDidLoad() {
        super.viewDidLoad()
        chatHistory?.reverse()

        tableView.delegate = self
  //       DataService.shared.getChatHistory()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        navigationItem.title = DataService.shared.data?.room[DataService.shared.indexOfPeople!]?.frd_name
        
    }
    
    func scrollToLastMessage() {
        guard chatHistory?.count != nil else {return}
        if chatHistory?.count != 0 {
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if self.chatHistory?.count != 0 {
                    let indexPath = IndexPath(item: (self.chatHistory?.count)! - 1 , section: 0)
                    self.messageTableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
                }
            })
        }
    }
    
    
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let keyboardIsShowing = notification.name ==  NSNotification.Name.UIKeyboardWillShow
            bottomOfMessageViewConstraint.constant = keyboardIsShowing ? -keyboardFrame!.height + 45 : 0
            scrollToLastMessage()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    // MARK: - TBV DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextView.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = chatHistory![indexPath.row].is_own == true ? "sentCell" : "reciveCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        
        cell.messageText.text = chatHistory![indexPath.row].content
        
        
        
        return cell
    }
    
    @objc func updateData() {
        chatHistory = DataService.shared.data?.room[DataService.shared.indexOfPeople!]?.message
        tableView.reloadData()
        scrollToLastMessage()
    }
    @IBAction func sendMessage(sender: UIButton) {
    }
    
    
    
    
}

