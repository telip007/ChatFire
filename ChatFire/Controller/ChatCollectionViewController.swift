//
//  ChatCollectionViewController.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let reuseIdentifier2 = "Cell2"

extension ChatCollectionViewController{
    func observeForMessages(){
        messagesRef?.observeEventType(.ChildAdded, withBlock: { (data) in
            if data.value is NSNull{
                print("No messages :(")
            }
            else{
                if let msData = data.value as? [String: AnyObject]{
                    let message = Message()
                    message.key = data.key
                    message.setValuesForKeysWithDictionary(msData)
                    self.messages.append(message)
                    self.messages.sortInPlace{$0.createDate!.compare($1.createDate!) == .OrderedAscending}
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView?.reloadData()
                        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
                        let lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
                        self.collectionView?.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
                    })
                }
            }
        })
    }
}

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let messageBar: TypeView = {
        let mb = TypeView(frame: CGRect(x:0,y:0,width: 0,height: 60))
        return mb
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        iv.contentMode = .ScaleAspectFit
        iv.layer.cornerRadius = 5.0
        iv.layer.masksToBounds = true
        iv.userInteractionEnabled = true
        return iv
    }()
    
    var chatId: String?
    
    var user: User?
        
    var messagesRef: FIRDatabaseReference?
    
    lazy var messages = [Message]()
    
    var url: String?
    
    override var inputAccessoryView: UIView! {
        get {
            return messageBar
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        view.backgroundColor = .whiteColor()
        collectionView?.backgroundColor = .whiteColor()
        collectionView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .Interactive
        let tap = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        tap.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnProfileImage(_:)))
        imageView.addGestureRecognizer(tap)
        imageView.loadImageFromUrl(url!)
        let imageItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = imageItem
        ref?.child("users/\(currentUser!.uid)/partners/\(user!.uid!)").observeSingleEventOfType(.Value, withBlock: { (data) in
            if data.value is NSNull{
                let chatId = NSUUID().UUIDString
                self.chatId = chatId
                self.messagesRef = ref?.child("messages/\(self.chatId!)")
                self.observeForMessages()
            }
            else {
                guard let chatId = data.value as? String
                    else{fatalError("Why?")}
                self.chatId = chatId
                self.messagesRef = ref?.child("messages/\(self.chatId!)")
                self.observeForMessages()
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        collectionView?.registerClass(IncomingChatBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.registerClass(OutgoingChatBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        messageBar.sendButton.addTarget(self, action: #selector(sendMessage), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.messages.removeAll()
        dispatch_async(dispatch_get_main_queue()) { 
            self.collectionView?.reloadData()
        }
        messagesRef?.removeAllObservers()
    }

    func sendMessage(){
        Message.sendMessage(currentUser!.uid, chatId: chatId!, message: messageBar.typingView.text!, user: self.user!)
        messageBar.typingView.text = "Write message..."
        messageBar.typingView.textColor = .lightGrayColor()
        messageBar.typingView.resignFirstResponder()
        messageBar.invalidateIntrinsicContentSize()
    }
    
    func stopEditing(){
        messageBar.typingView.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        if message.senderId! != currentUser!.uid{
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? IncomingChatBubbleCollectionViewCell
                else{return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)}
            cell.contentTextView.snp_updateConstraints(closure: { (make) in
                make.width.equalTo(message.message!.getRectFromString(200).width + 25)
            })
            
            cell.bubbleView.snp_updateConstraints(closure: { (make) in
                make.width.equalTo(message.message!.getRectFromString(200).width + 25)
            })
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            
            
            cell.profileImageView.loadImageFromUrl(url!)
            
            dispatch_async(dispatch_get_main_queue()) {
                cell.contentTextView.text = message.message!
            }
            
            cell.alpha = 0
            
            return cell
        }
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2, forIndexPath: indexPath) as? OutgoingChatBubbleCollectionViewCell
            else{return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2, forIndexPath: indexPath)}
        
        cell.contentTextView.snp_updateConstraints(closure: { (make) in
            make.width.equalTo(message.message!.getRectFromString(200).width + 25)
        })
        
        cell.bubbleView.snp_updateConstraints(closure: { (make) in
            make.width.equalTo(message.message!.getRectFromString(200).width + 25)
        })
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
        dispatch_async(dispatch_get_main_queue()) {
            cell.contentTextView.text = message.message!
        }
        
        cell.alpha = 0
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.5) {
                cell.alpha = 1
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.5) {
                cell.alpha = 0
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height: CGFloat?
        if let message = messages[indexPath.row].message {
            height = message.getRectFromString(200).height
        }
        
        return CGSize(width: self.view.bounds.width, height: height! + 20)
    }
    

}



extension ChatCollectionViewController{
    func handleTapOnProfileImage(sender: UITapGestureRecognizer){
            let vc = ImageZoomViewController()
            vc.url = url!
            vc.title = "\(user!.username!)"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
    }
}






