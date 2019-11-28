//
//  LinkDetailViewController.swift
//  Share It Fast
//
//  Created by Neil Richter on 28/11/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import Foundation
import UIKit

class LinkDetailViewController: UIViewController {
    var link: LinkItem!
    let modalTitle: UILabel = UILabel()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.initView()
    }
    
    func initView() {
        self.imageView.downloaded(from: self.link!.link)
    }
}
