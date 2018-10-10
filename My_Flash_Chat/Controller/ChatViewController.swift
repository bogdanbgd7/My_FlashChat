//
//  ViewController.swift
//  My_Flash_Chat
//
//  Created by Bogdan Ponocko on 10/7/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    
    var messageArray : [Message] = [Message]() //empty array
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        
        messageTextfield.delegate = self
        
        
        
        
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        //TODO: Register your MessageCell.xib file here:
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none //brise onu sivu liniju u chatu
        
        
        
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        
        //onaj koji salje
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }
        else { //poruka drugog korisnika
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        return cell //Ako je output ->UITableViewCell, onda mora return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 3 - hardcoded
        return messageArray.count
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2 //pravi dve sekcije
    //    }
    
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true)
        
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() { //sluzi da ne bude ruzan chet
        
        messageTableView.rowHeight = UITableView.automaticDimension //podesava da ne bude retardirano
        messageTableView.estimatedRowHeight = 120.0
    }
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){ //lepse izgleda, smooth feeling
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded() //if constraint has changed, or something in the view changed, we update that
        }
        
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded() //update view
            
        }
        
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!] //sender je onaj koji je trenutno ulogovan(gleda se preko maila)
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                print("MESSAGE SAVED SUCCESSFULY")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = ""
            }
        } //receiving messageDictionary inside a messageDB under automatically generated ID
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>  // .value is Any? data type
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData() //every single time we add new data, it will trigger .observer
            
        }
        
    }
    
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do{ // *do* koristimo kada imamo nesto problematicno, pa da ga malo ovo ono neki try catch da se baci
            
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true) //vraca ga na HOME aplikacije, odnosno WelcomeVC
        }
        catch{
            
            print("Error! There was a problem signing out.")
            
        }
        
        
    }
    
    
    
}
