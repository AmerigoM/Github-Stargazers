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
    let GITHUB_URL = "https://api.github.com/repos/AmerigoM/Clima/stargazers"
    let stargazers = "stargazers"
    
    @IBOutlet weak var ownerLabel: UITextField!
    @IBOutlet weak var repoLabel: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
    }

    @IBAction func search(_ sender: UIButton) {
        if !(ownerLabel.text ?? "").isEmpty {
            print("Owner not null")
        } else {
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Warning", message: "Input fields cannot be empty!", preferredStyle: .alert)
            
            // Create OK button without action handler
            let ok = UIAlertAction(title: "OK", style: .default)
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        /*
        let params : [String : String] = ["owner" : ownerLabel.text!, "repo" : repoLabel.text!, "stargazers" : stargazers]
        */
    }
    
    
    // MARK: - Networking
    
    func getGithubData(url: String, parameters: [String : String]) {
        // http request to the server
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success")
                print(response)
            } else {
                print("Failure")
                print(response)
            }
        }
    }
    
    
}

