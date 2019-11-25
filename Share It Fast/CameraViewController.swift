//
//  ViewController.swift
//  Share It Fast
//
//  Created by Neil Richter on 31/10/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    var imageView: UIImageView = UIImageView()
    var pickButton: UIButton = UIButton()
    var sendButton: UIButton = UIButton()
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.contentMode = .scaleAspectFit
        
        self.pickButton.setTitle("Pick image", for: .normal)
        self.pickButton.setTitleColor(.systemBlue, for: .normal)
        self.pickButton.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.setTitleColor(.systemBlue, for: .normal)
        self.sendButton.isHidden = true

        self.view.grid(child: self.imageView, x: 0, y: 0, height: 8, width: 12)
        self.view.grid(child: self.pickButton, x: 4, y: 8, height: 1/2, width: 4)
        self.view.grid(child: self.sendButton, x: 4, y: 17/2, height: 1/2, width: 4)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @objc func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
}

extension CameraViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
        self.sendButton.isHidden = false
    }
}
