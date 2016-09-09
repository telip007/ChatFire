//
//  Message.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var key: String?
    var senderId: String?
    var message: String?
    var createdDate: NSNumber?{
        didSet{
            createNSDate()
        }
    }
    var createDate: NSDate?
    
    func createNSDate(){
        if let createdDate = createdDate as? NSTimeInterval{
            createDate = NSDate(timeIntervalSince1970: createdDate/1000)
        }
    }
    
    
    class func sendMessage(sender: String, chatId: String, message: String, user: User){
        ref?.child("users/\(currentUser!.uid)/partners/\(user.uid!)").observeSingleEventOfType(.Value, withBlock: { (data) in
            if data.value is NSNull{
                let messageRef = ref?.child("messages/\(chatId)").childByAutoId()
                let messageValue = [
                    "message": message,
                    "senderId": sender,
                    "createdDate": FIRServerValue.timestamp()
                ]
                let chatData = [
                    "chatId": chatId,
                    "user1": user.uid!,
                    "user2": currentUser!.uid,
                    "lastMessageDate": FIRServerValue.timestamp(),
                    "lastMessage": message
                ]
                ref?.child("chats/\(chatId)").setValue(chatData)
                ref?.child("users/\(currentUser!.uid)/partners/\(user.uid!)").setValue(chatId)
                ref?.child("users/\(user.uid!)/partners/\(currentUser!.uid)").setValue(chatId)
                ref?.child("users/\(currentUser!.uid)/chats/\(chatId)").setValue(chatData)
                ref?.child("users/\(user.uid!)/chats/\(chatId)").setValue(chatData)
                messageRef?.setValue(messageValue)
            }
            else{
                let messageRef = ref?.child("messages/\(chatId)").childByAutoId()
                let messageValue = [
                    "message": message,
                    "senderId": sender,
                    "createdDate": FIRServerValue.timestamp()
                ]
                let chatData = [
                    "lastMessageDate": FIRServerValue.timestamp(),
                    "lastMessage": message
                ]
                
                ref?.child("chats/\(chatId)").updateChildValues(["lastMessageDate": FIRServerValue.timestamp(), "lastMessage": message])
                ref?.child("users/\(currentUser!.uid)/chats/\(chatId)").updateChildValues(chatData as! [String: AnyObject])
                ref?.child("users/\(user.uid!)/chats/\(chatId)").updateChildValues(chatData as! [String: AnyObject])
                messageRef?.setValue(messageValue)
            }
        })
    }
    
}
