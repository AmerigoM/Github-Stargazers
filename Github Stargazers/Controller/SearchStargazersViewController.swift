//
//  ViewController.swift
//  Github Stargazers
//
//  Created by Amerigo Mancino on 29/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchStargazersViewController: UIViewController {
    
    // Constants
    let GITHUB_URL = "https://api.github.com/repos"
    
    // Outlets
    @IBOutlet weak var ownerLabel: UITextField!
    @IBOutlet weak var repoLabel: UITextField!
    
    private var userList = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func search(_ sender: UIButton) {
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
        Alamofire.request(trueUrl, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let usersJSON: JSON = JSON(response.result.value!)
                
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
    
    
}

