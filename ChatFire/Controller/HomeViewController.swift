//
//  HomeViewController.swift
//  ChatFire
//
//  Created by Talip Göksu on 30.08.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    lazy var chats = [Chat]()
    
    var chatsRef: FIRDatabaseReference?
    
    var handle: FIRDatabaseHandle?
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.registerClass(ChatsTableViewCell.self, forCellReuseIdentifier: "cell")
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(self.refreshTable(_:)), forControlEvents: .ValueChanged)
        return rf
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        User.getCurrentUser({ (user) in
            self.navigationItem.title = user.username!
        })
        chatsRef = ref?.child("users/\(currentUser!.uid)/chats")
        let logoutItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutItem
        navigationItem.title = "Home"
        view.addSubview(tableView)
        tableView.addSubview(self.refreshControl)
        layoutTableView()
        observForChats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutTableView(){
        tableView.snp_makeConstraints { (make) in
            make.center.equalTo(view.snp_center)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func logout(){
        try! FIRAuth.auth()?.signOut()
    }
}

extension HomeViewController{
    func refreshTable(refreshControl: UIRefreshControl){
        self.handle = nil
        self.chatsRef?.removeAllObservers()
        self.chats.removeAll(keepCapacity: false)
//        dispatch_async(dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//        }
        observForChats()
    }
}

extension HomeViewController {
    func observForChats(){
//        self.refreshControl.beginRefreshing()
        chatsRef?.queryOrderedByChild("lastMessageDate").observeEventType(.ChildAdded, withBlock: { (userSnap) in
            if let chatData = userSnap.value as? [String: AnyObject]{
                let chat = Chat()
                chat.setValuesForKeysWithDictionary(chatData)
                self.handle = self.setupMessageListener()
                self.chats.append(chat)
                self.chats.sortInPlace{$0.lastDate < $1.lastDate}
                self.tableView.reloadData()
                if self.refreshControl.refreshing{
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }
    
    func setupMessageListener() -> FIRDatabaseHandle{
        return chatsRef!.observeEventType(.ChildChanged, withBlock: { (data) in
            let key = data.key
            if let newChat = data.value as? [String: AnyObject]{
                for chat in self.chats.reverse(){
                    if chat.chatId! == key{
                        chat.setValuesForKeysWithDictionary(newChat)
                        self.chats.sortInPlace{$0.lastDate < $1.lastDate}
                        self.tableView.reloadData()
                        break
                    }
                }
            }
        })
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? ChatsTableViewCell
            else{return UITableViewCell()}
        cell.profileImageView.image = nil
        let chat = self.chats.reverse()[indexPath.row]
        User.userFromId(chat.partner!) { (user) in
            dispatch_async(dispatch_get_main_queue()) {
                cell.textLabel!.text = user.username!
                if let message = chat.lastMessage{
                    cell.detailTextLabel?.text = message
                }
                if let time = chat.lastDate{
                    cell.timeLabel.text = time
                }
                
                let rect = chat.lastDate!.getRectFromString(100)
                cell.timeLabel.snp_updateConstraints { (make) in
                    make.width.equalTo(rect.width)
                    make.height.equalTo(rect.height + 20)
                }
            }
            
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnProfileImage(_:)))
        tap.delaysTouchesBegan = true
        cell.profileImageView.addGestureRecognizer(tap)
        cell.profileImageView.tag = indexPath.row
        chat.getImage { (imageUrl) in
            cell.profileImageView.loadImageFromUrl(imageUrl)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .Vertical
        let vc = ChatCollectionViewController(collectionViewLayout: flow)
        let chat = self.chats.reverse()[indexPath.row]
        User.userFromId(chat.partner!) { (user) in
            vc.user = user
            vc.url = user.profile_image!
            vc.title = "\(user.username!)"
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleTapOnProfileImage(sender: UITapGestureRecognizer){
        if let imageView = sender.view as? UIImageView{
            let vc = ImageZoomViewController()
            let chat = chats[imageView.tag]
            User.userFromId(chat.partner!) { (user) in
                vc.url = user.profile_image!
                vc.title = "\(user.username!)"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let chat = self.chats.reverse()[indexPath.row]
            tableView.beginUpdates()
            ref?.child("users/\(chat.user1!)/chats/\(chat.chatId!)").removeValue()
            ref?.child("users/\(chat.user2!)/chats/\(chat.chatId!)").removeValue()
            ref?.child("users/\(chat.user1!)/partners/\(chat.user2!)").removeValue()
            ref?.child("users/\(chat.user2!)/partners/\(chat.user1!)").removeValue()
            ref?.child("chats/\(chat.chatId!)").removeValue()
            ref?.child("messages/\(chat.chatId!)").removeValue()
            chats.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
            
        }
    }
    
}


