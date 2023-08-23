//
//  UserListViewController.swift
//  UserFlow
//
//  Created by Yogesh Patel on 20/11/21.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userArray = DatabaseHelper.shareInstance.getAllUsers()
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell") 
    }
    
}

extension UserListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else{
            return UITableViewCell()
        }
        cell.userDetailConfiguration(user: userArray[indexPath.row])
        return cell
    }
}

extension UserListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DatabaseHelper.shareInstance.deleteUser(user: userArray[indexPath.row])
            userArray.remove(at: indexPath.row)            
            tableView.reloadData()
        }
    }
}
