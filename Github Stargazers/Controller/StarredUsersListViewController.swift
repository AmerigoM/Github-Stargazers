//
//  StarredUsersListViewController.swift
//  Github Stargazers
//
//  Created by Amerigo Mancino on 29/10/2020.
//

import UIKit

// MARK: - Custom Cell

class UserCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
}

class StarredUsersListViewController: UITableViewController {
    
    var userList = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "resultView"

        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userList.count == 0 {
            self.tableView.setEmptyMessage("This repository has no stargazers.")
        } else {
            self.tableView.restore()
        }
        
        return self.userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        cell.usernameLabel.text = self.userList[indexPath.row].username
        cell.avatarImageView.imageFromServerURL(urlString: self.userList[indexPath.row].imageLink)
        cell.selectionStyle = .none // rows not selectable

        return cell
    }

}

// MARK: - Extensions

extension UIImageView {

 public func imageFromServerURL(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
