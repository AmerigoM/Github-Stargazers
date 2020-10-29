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

        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }}
