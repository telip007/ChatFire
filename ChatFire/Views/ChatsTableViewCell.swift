//
//  ChatsTableViewCell.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

//
//  ChooseUserTableViewCell.swift
//  ChatFire
//
//  Created by Talip Göksu on 05.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFit
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.userInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGrayColor()
        lb.font = UIFont.boldSystemFontOfSize(14.0)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let textLabel = textLabel
            else{fatalError("opps")}
        guard let detailTextLabel = detailTextLabel
            else{fatalError("opps")}
        
        
        textLabel.frame = CGRectMake(85, textLabel.frame.origin.y, textLabel.frame.width, textLabel.frame.height)
        detailTextLabel.frame = CGRectMake(85, detailTextLabel.frame.origin.y, detailTextLabel.frame.width, detailTextLabel.frame.height)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .whiteColor()
        backgroundColor = .whiteColor()
        contentView.addSubview(profileImageView)
        contentView.addSubview(timeLabel)
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutViews(){
        profileImageView.snp_makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left).offset(12)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(contentView.snp_right).offset(-12)
            make.top.equalTo(contentView.snp_top)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

