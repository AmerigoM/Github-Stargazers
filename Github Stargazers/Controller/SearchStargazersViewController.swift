//
//  ViewController.swift
//  Github Stargazers
//
//  Created by Amerigo Mancino on 29/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchStargazersViewController: UIViewController, UITextFieldDelegate {
    
    // Constants
    let GITHUB_URL = "https://api.github.com/repos"
    
    // Outlets
    @IBOutlet weak var ownerLabel: UITextField!
    @IBOutlet weak var repoLabel: UITextField!
    
    private var userList = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownerLabel.delegate = self
        self.repoLabel.delegate = self
        self.repoLabel.returnKeyType = UIReturnKeyType.go
        
        // always adopt a light interface style
        overrideUserInterfaceStyle = .light
        
        // looks for single or multiple taps
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ownerLabel.text = ""
        repoLabel.text = ""
    }

    @IBAction func search(_ sender: UIButton) {
        checkFieldsBeforeNetworkCall()
    }
    
    func checkFieldsBeforeNetworkCall() {
        self.view.endEditing(true)
        if let owner = ownerLabel.text, let repo = repoLabel.text, !owner.isEmpty, !repo.isEmpty {
            userList = []
            getGithubData(url: GITHUB_URL, owner: owner, repo: repo)
        } else {
            displayAlert(title: "Warning", message: "Input fields cannot be empty.")
        }
    }
    
    
    // MARK: - Networking
    
    func getGithubData(url: String, owner: String, repo: String) {
        // http request to the server
        let trueUrl = url + "/" + owner + "/" + repo + "/stargazers"
        let headers = ["accept" : "application/vnd.github.v3+json"]
        let parameters = ["per_page": 100]
        Alamofire.request(trueUrl, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                let usersJSON: JSON = JSON(response.result.value!)
                if usersJSON.type == .dictionary {
                    self.displayAlert(title: "Warning", message: "Repository or user do not exist.")
                } else if usersJSON.type == .array {
                    // json returned a list of github users
                    let jsonArray = usersJSON.array!
                    for item in jsonArray {
                        let user = User()
                        user.username = item["login"].stringValue
                        user.imageLink = item["avatar_url"].stringValue
                        self.userList.append(user)
                    }
                    self.performSegue(withIdentifier: "segueToList", sender: self)
                } else {
                    self.displayAlert(title: "Request failure", message: "Please contact the app support.")
                }
            } else {
                self.displayAlert(title: "Request failure", message: "Please contact the app support.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToList" {
            let destinationVC = segue.destination as! StarredUsersListViewController
            destinationVC.userList = self.userList
        }
    }
    
    
    // MARK: - Support functions
    
    func displayAlert(title: String, message: String) {
        // Create new alert
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button without action handler
        let ok = UIAlertAction(title: "OK", style: .default)
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // Called when the tap action is recognized
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.ownerLabel:
            self.repoLabel.becomeFirstResponder()
        case self.repoLabel:
            self.repoLabel.resignFirstResponder()
            self.checkFieldsBeforeNetworkCall()
        default:
            self.view.endEditing(true)
        }
    }
    
}

