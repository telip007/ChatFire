//
//  TypeView.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit
import SnapKit

class TypeView: UIView, UITextViewDelegate{
    
    private let minimumHeight: CGFloat = 60.0
    private let maximumHeight: CGFloat = 80.0
    
    let typingView: UITextView = {
        let tv = UITextView()
        tv.userInteractionEnabled = true
        tv.enablesReturnKeyAutomatically = true
        tv.textColor = .lightGrayColor()
        tv.backgroundColor = .whiteColor()
        tv.font = UIFont.systemFontOfSize(16.0)
        tv.text = "Write message..."
        tv.scrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let sendButton: UIButton = {
        let sb = UIButton()
        sb.setTitleColor(UIColor(hex: 0x0099E8), forState: .Normal)
        sb.setTitle("Send", forState: .Normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteColor()
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        layer.shadowRadius = 0.5
        layer.shadowColor = UIColor.darkGrayColor().CGColor
        addSubview(typingView)
        addSubview(sendButton)
        typingView.delegate = self
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    func setupConstraints(){
        typingView.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(12)
            make.right.equalTo(sendButton.snp_left).offset(-12)
            make.top.equalTo(self.snp_top).offset(8)
            make.bottom.equalTo(self.snp_bottom).offset(-8)
        }
        sendButton.snp_makeConstraints { (make) in
            make.width.equalTo(50)
            make.right.equalTo(self.snp_right).offset(-15)
            make.top.equalTo(self.snp_top).offset(8)
            make.bottom.equalTo(self.snp_bottom).offset(-8)
        }
    }
    
    func getHeightForTextView(string: String) -> CGFloat{
        let rect = string.getRectFromString(200)
        return rect.height + 20
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == .lightGrayColor() {
            textView.text = nil
            textView.textColor = .darkGrayColor()
            invalidateIntrinsicContentSize()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write message..."
            textView.textColor = .lightGrayColor()
            invalidateIntrinsicContentSize()
        }
        invalidateIntrinsicContentSize()
    }
    
    func textViewDidChange(textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let textSize = getHeightForTextView(typingView.text)
        if textSize < minimumHeight{
            typingView.scrollEnabled = false
            return CGSize(width: self.bounds.width, height: minimumHeight)
        }
        else if textSize >= maximumHeight{
            typingView.scrollEnabled = true
            return CGSize(width: self.bounds.width, height: maximumHeight)
        }
        typingView.scrollEnabled = false
        return CGSize(width: self.bounds.width, height: textSize)
    }
    
   
    
    
}
