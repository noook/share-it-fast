//
//  ViewController.swift
//  Share It Fast
//
//  Created by Neil Richter on 31/10/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var linkItems = [LinkItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkItems = LinkItem.loadLinks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.linkItems = LinkItem.loadLinks()
        self.tableView.reloadData()
        print(self.linkItems)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copy = self.copyAction(at: indexPath)
        let share = self.shareAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [copy, share])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.linkItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkItemCell", for: indexPath)
        
        let linkItem = self.linkItems[indexPath.row]
        cell.textLabel?.text = linkItem.link
        cell.detailTextLabel?.text = linkItem.timestamp.toString(format: "dd-MM-yyyy HH:mm:ss")
        
        return cell
    }
    
    func copyAction(at indexPath: IndexPath) -> UIContextualAction {
        let link = self.linkItems[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Copy") { (action, view, completion) in
            completion(true)
        }
        

        action.backgroundColor = .systemPurple
        
        return action
    }
    
    func shareAction(at indexPath: IndexPath) -> UIContextualAction {
        let link = self.linkItems[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Share") { (action, view, completion) in
            completion(true)
        }
        
        action.backgroundColor = .systemBlue
        
        return action
    }
}

