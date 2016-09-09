//
//  String+CGRect.swift
//  ChatFire
//
//  Created by Talip Göksu on 06.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

extension String{
    func getRectFromString(width: CGFloat) -> CGRect{
        let size = CGSize(width: width, height: CGFloat.max)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: self).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil)
    }
}