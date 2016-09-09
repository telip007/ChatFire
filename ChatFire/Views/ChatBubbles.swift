//
//  ChatBubbleCollectionViewCell.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

private let minimumWidth = 200

class IncomingChatBubbleCollectionViewCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .ScaleAspectFit
        piv.translatesAutoresizingMaskIntoConstraints = false
        return piv
    }()
    
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(16.0)
        tv.backgroundColor = UIColor(hex: 0xEEEEEE)
        tv.textColor = .darkGrayColor()
        tv.contentInset = UIEdgeInsets(top: tv.contentInset.top, left: tv.contentInset.left + 7, bottom: tv.contentInset.bottom, right: tv.contentInset.right)
        tv.userInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor(hex: 0xEEEEEE)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(bubbleView)
        addSubview(contentTextView)
    }
    
    func setupConstraints(){
        
        profileImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(8)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        bubbleView.snp_makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp_right).offset(8)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(200)
            make.height.equalTo(self.snp_height)
        }
        contentTextView.snp_makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp_right).offset(8)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(200)
            make.height.equalTo(self.snp_height)
        }
    }
    
}


class OutgoingChatBubbleCollectionViewCell: UICollectionViewCell {
    
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(16.0)
        tv.backgroundColor = UIColor(hex: 0x0099E8)
        tv.textColor = .whiteColor()
        tv.contentInset = UIEdgeInsets(top: tv.contentInset.top, left: tv.contentInset.left + 7, bottom: tv.contentInset.bottom, right: tv.contentInset.right)
        tv.userInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor(hex: 0x0099E8)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    func setupViews() {
        addSubview(bubbleView)
        addSubview(contentTextView)
    }
    
    func setupConstraints(){
        bubbleView.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-12)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(200)
            make.height.equalTo(self.snp_height)
        }
        contentTextView.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-12)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(200)
            make.height.equalTo(self.snp_height)
        }
    }
    
}
