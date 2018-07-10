//
//  MemeDataManager.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/25/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import Foundation

class MemeDataManager {
    
    static let shared = MemeDataManager()
    
    private(set) var memes = [Meme]()
    
    private init() {
        //
    }
    
    func add(meme: Meme) {
        
        memes.append(meme)
        
        let name = Notification.Name("MemeAdded")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["meme": meme])
        
    }
    
}
