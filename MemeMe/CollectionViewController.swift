//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/25/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Collection"
        self.view.backgroundColor = UIColor.red
        
    
        let nib = UINib(nibName: MemeCollectionCell.identifier, bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: MemeCollectionCell.identifier)
        
        let name = Notification.Name("MemeAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(didAddMeme(_:)), name: name, object: nil)
        
    }
    
    @objc private func didAddMeme(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    
}
    


extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return MemeDataManager.shared.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionCell.identifier, for: indexPath) as? MemeCollectionCell
        cell?.meme = MemeDataManager.shared.memes[indexPath.item]
        return cell ?? UICollectionViewCell()
        
    }
    
}
