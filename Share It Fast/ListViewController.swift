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
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copy = self.copyAction(at: indexPath)
        let share = self.shareAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [copy, share])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.linkItems.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Links"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = self.linkItems[indexPath.row]
        self.performSegue(withIdentifier: "LinkDetail", sender: link)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkItemCell", for: indexPath)
        
        let linkItem = self.linkItems[indexPath.row]
        cell.textLabel?.text = linkItem.link
        cell.textLabel?.textColor = .systemBlue
        cell.detailTextLabel?.text = linkItem.timestamp.toString(format: "dd-MM-yyyy HH:mm:ss")
        cell.detailTextLabel?.textColor = .systemGray
        
        return cell
    }
    
    func copyAction(at indexPath: IndexPath) -> UIContextualAction {
        let link = self.linkItems[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Copy") { (action, view, completion) in
            UIPasteboard.general.string = link.link
            completion(true)
        }
        

        action.backgroundColor = .systemPurple
        
        return action
    }
    
    func shareAction(at indexPath: IndexPath) -> UIContextualAction {
        let link = self.linkItems[indexPath.row]
        let textShare = [link.link]
        let action = UIContextualAction(style: .normal, title: "Share") { (action, view, completion) in
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            completion(true)
        }
        
        action.backgroundColor = .systemBlue
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let open = openUrlAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [open])
    }
    
    func openUrlAction(at indexPath: IndexPath) ->UIContextualAction {
        let link = self.linkItems[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Open") { (action, view, completion) in
            if let url = URL(string: link.link) {
                UIApplication.shared.open(url)
            }
            completion(true)
        }

        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LinkDetail"){
            let vc = segue.destination as! LinkDetailViewController
            vc.link = (sender as! LinkItem)
        }
    }
}
