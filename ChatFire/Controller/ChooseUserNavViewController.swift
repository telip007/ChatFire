//
//  ChooseUserNavViewController.swift
//  ChatFire
//
//  Created by Talip Göksu on 04.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

class ChooseUserNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = ChooseUserViewController()
        vc.title = "Choose Users"
        self.viewControllers = [vc]
        self.title = "Choose Users"
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
