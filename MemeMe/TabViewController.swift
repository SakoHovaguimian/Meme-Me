//
//  TabViewController.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/25/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    
    
    @IBAction func presentMemeCreator(_ sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateViewController")
        let nav = UINavigationController(rootViewController: vc!)
        self.present(nav, animated: true, completion: nil)
        
    }
    
}
