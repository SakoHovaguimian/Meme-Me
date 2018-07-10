//
//  MemeCollectionCell.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/27/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionCell: UICollectionViewCell {
    
    static let identifier = "MemeCollectionCell"
    static let height: CGFloat = 100
    
    @IBOutlet weak var memeImageView: UIImageView!

    var meme: Meme? {
        didSet {
        guard let meme = meme else { return }
        layout(for: meme)
    }
   
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        memeImageView.image = nil
     
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func layout(for meme: Meme) {
        
        memeImageView.image = meme.memeImage
    }
}
