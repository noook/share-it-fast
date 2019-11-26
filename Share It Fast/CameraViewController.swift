//
//  ViewController.swift
//  Share It Fast
//
//  Created by Neil Richter on 31/10/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import UIKit
import Alamofire

class CameraViewController: UIViewController {
    var imageView: UIImageView = UIImageView()
    var pickButton: UIButton = UIButton()
    var sendButton: UIButton = UIButton()
    var connectionSettings: [String: String] = [:]
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let retrievedDict = UserDefaults.standard.dictionary(forKey: "connectionSettings") {
            self.connectionSettings = retrievedDict as! [String: String]
        }
        
        self.imageView.contentMode = .scaleAspectFit
        
        self.pickButton.setTitle("Pick image", for: .normal)
        self.pickButton.setTitleColor(.systemBlue, for: .normal)
        self.pickButton.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.setTitleColor(.systemBlue, for: .normal)
        self.sendButton.isHidden = true
        self.sendButton.addTarget(self, action: #selector(sendImage(_:)), for: .touchUpInside)

        self.view.grid(child: self.imageView, x: 0, y: 0, height: 8, width: 12)
        self.view.grid(child: self.pickButton, x: 4, y: 8, height: 1/2, width: 4)
        self.view.grid(child: self.sendButton, x: 4, y: 17/2, height: 1/2, width: 4)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @objc func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @objc func sendImage(_ sender: UIButton) {
        let imgData = self.imageView.image!.pngData()
        self.showSpinner(onView: self.view)
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in self.connectionSettings {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(imgData!, withName: "file", fileName: "file.png", mimeType: "image/jpg")
        }, to: "https://neko.nook.sh/file")
            .responseJSON { response in
                self.removeSpinner()
                let link: String = (response.value! as! [String: String])["link"]!
                self.alertSuccess()
                self.saveLink(link: link)
            }
    }
    
    func alertSuccess() {
        let alert = UIAlertController(title: nil, message: "Success uploading the file", preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
    func saveLink(link: String) {
        var links = LinkItem.loadLinks()
        links.insert(LinkItem(link: link, timestamp: Date.init()), at: 0)
        LinkItem.save(elements: links)
        self.tabBarController?.selectedIndex = 0
    }
}

extension CameraViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
        self.sendButton.isHidden = false
    }
}
