//
//  HomeNavViewController.swift
//  ChatFire
//
//  Created by Talip Göksu on 04.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

class HomeNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = HomeViewController()
        self.viewControllers = [vc]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
