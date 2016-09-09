//
//  ImageZoomViewController.swift
//  ChatFire
//
//  Created by Talip Göksu on 07.09.16.
//  Copyright © 2016 ChatFire. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController {
    
    var url: String?
    
    var zoomedImage: UIImageView = {
        let ziv = UIImageView()
        ziv.contentMode = .ScaleAspectFit
        ziv.layer.cornerRadius = 5
        ziv.layer.masksToBounds = true
        ziv.translatesAutoresizingMaskIntoConstraints = false
        return ziv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        zoomedImage.loadImageFromUrl(url!)
        
//        navigationController?.hidesBarsOnTap = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleNav(_:)))
        view.addGestureRecognizer(tap)
        
        view.addSubview(zoomedImage)
        layoutView()
    }
    
    func toggleNav(sender: UITapGestureRecognizer){
        if navigationController?.navigationBarHidden == true{
            navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animateWithDuration(0.3, animations: {
               self.view.backgroundColor = .whiteColor()
            })
        }
        else{
            navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animateWithDuration(0.3, animations: {
                self.view.backgroundColor = .blackColor()
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutView(){
        zoomedImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
        }
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
