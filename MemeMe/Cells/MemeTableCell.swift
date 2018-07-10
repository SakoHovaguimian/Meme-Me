//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/25/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    
    static let identifier = "MemeTableCell"
    static let height: CGFloat = 100
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var meme: Meme? {
        didSet {
            
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        memeImageView.image = nil
        label.text = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func layout(for meme: Meme) {
        
        memeImageView.image = meme.memeImage
        label.text = "\(meme.topText ?? "No top") | \(meme.bottomText ?? "No bottom")"
        
    }
    
}
