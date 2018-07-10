//
//  TableViewController.swift
//  MemeMe
//
//  Created by Sako Hovaguimian on 3/25/18.
//  Copyright © 2018 Sako Hovaguimian. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Table"
        self.view.backgroundColor = UIColor.red
        
        let nib = UINib(nibName: MemeTableCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MemeTableCell.identifier)
        
        let name = Notification.Name("MemeAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(didAddMeme(_:)), name: name, object: nil)
        
    }
    
    @objc private func didAddMeme(_ notification: Notification) {
        tableView.reloadData()
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeDataManager.shared.memes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MemeTableCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableCell.identifier) as? MemeTableCell
        cell?.meme = MemeDataManager.shared.memes[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
}

