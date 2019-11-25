//
//  ViewController.swift
//  Share It Fast
//
//  Created by Neil Richter on 31/10/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var currentTag = 0
    
    var usernameInput: TextField?
    var passwordInput: TextField?
    var hostInput: TextField?
    var portInput: TextField?
    var remotePathInput: TextField?
    var remoteUrlInput: TextField?

    override func viewDidLoad() {
        loadElements()
    }
    
    func loadElements() {
        self.hostInput = basicInput(keyboardType: .URL)
        self.portInput = basicInput(keyboardType: .numberPad, placeholder: "22")
        self.usernameInput = basicInput()
        self.passwordInput = basicInput(secret: true)
        self.remotePathInput = basicInput(placeholder: "~")
        self.remoteUrlInput = basicInput(keyboardType: .URL, placeholder: "https://domain.tld")

        self.view.grid(child: label(title: "Host:"), x: 1, y: 1, height: 1/2, width: 10)
        self.view.grid(child: self.hostInput!, x: 1, y: 3/2, height: 1/2, width: 10)
        self.view.grid(child: label(title: "Port:"), x: 1, y: 2, height: 1/2, width: 10)
        self.view.grid(child: self.portInput!, x: 1, y: 5/2, height: 1/2, width: 10)
        self.view.grid(child: label(title: "Username:"), x: 1, y: 3, height: 1/2, width: 10)
        self.view.grid(child: self.usernameInput!, x: 1, y: 7/2, height: 1/2, width: 10)
        self.view.grid(child: label(title: "Password:"), x: 1, y: 4, height: 1/2, width: 10)
        self.view.grid(child: self.passwordInput!, x: 1, y: 9/2, height: 1/2, width: 10)
        self.view.grid(child: label(title: "Remote path:"), x: 1, y: 5, height: 1/2, width: 10)
        self.view.grid(child: self.remotePathInput!, x: 1, y: 11/2, height: 1/2, width: 10)
        self.view.grid(child: label(title: "Remote URL:"), x: 1, y: 6, height: 1/2, width: 10)
        self.view.grid(child: self.remoteUrlInput!, x: 1, y: 13/2, height: 1/2, width: 10)
        
        self.view.grid(child: newButton(title: "Test connection"), x: 1, y: 15/2, height: 1/2, width: 10)
    }
    
    func basicInput(
        keyboardType: UIKeyboardType? = .default,
        returnKeyType: UIReturnKeyType? = .next,
        secret: Bool? = false,
        placeholder: String? = ""
    ) -> TextField {
        let input: TextField = TextField()
        input.keyboardType = keyboardType!
        input.placeholder = placeholder!
        input.borderStyle = .roundedRect
        input.autocapitalizationType = .none
        input.isSecureTextEntry = secret!
        input.tag = self.currentTag
        input.returnKeyType = returnKeyType!
        input.delegate = self
        self.currentTag += 1
        
        return input
    }
    
    func newButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(testConnection(_:)), for: .touchUpInside)

        return button
    }
    
    @objc func testConnection(_ sender: UIButton) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        let parameters: [String: String] = [
            "username": self.usernameInput!.text!,
            "password": self.passwordInput!.text!,
            "host": self.hostInput!.text!,
            "port": self.portInput!.text!,
            "remotePath": self.remotePathInput!.text!,
            "remoteUrl": self.remoteUrlInput!.text!,
        ]

        self.showSpinner(onView: self.view)
        AF.request(
            "https://neko.nook.sh/credentials",
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        ).response { response in
            debugPrint(response)
            self.removeSpinner()
            if (response.response?.statusCode == 401) {
                self.alert(message: "Invalid credentials")
            } else if (response.response?.statusCode == 200) {
                self.alert(message: "Connection successful")
                UserDefaults.standard.set(parameters, forKey: "connectionSettings")
                self.tabBarController?.selectedIndex = 1
            } else if (response.response?.statusCode == 400) {
                self.alert(message: "Remote path does not exist+")
            }
        }
    }
    
    func alert(message: String) {
        let alert = UIAlertController(
            title: "Etat de la connexion",
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    func label(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        
        return label
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          textField.resignFirstResponder()
       }
        
       return true
    }
}

