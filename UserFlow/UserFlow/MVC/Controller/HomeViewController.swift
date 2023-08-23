//
//  HomeViewController.swift
//  UserFlow
//
//  Created by Yogesh Patel on 16/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
}

extension HomeViewController{
    
    func configuration(){
        addButtons()
        navigationController?.isNavigationBarHidden = false
    }
    
    func addButtons(){
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logout
        
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(profileButtonTapped))
        let userList = UIBarButtonItem(title: "UserList", style: .plain, target: self, action: #selector(userListTapped))
        
        navigationItem.leftBarButtonItems = [profile, userList]
    }
    
    @objc
    func userListTapped(){
        if let userListViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController{
            self.navigationController?.pushViewController(userListViewController, animated: true)
        }
    }
    
    @objc
    func logoutTapped(){
        UserDefaults.standard.removeObject(forKey: "emailKey")//remove kiya
        print(UserDefaults.standard.value(forKey: "emailKey"))
        
        
        let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
        if let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            let loginNavigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = loginNavigationController
            window?.makeKeyAndVisible()
        }
        
    }
    
    @objc
    func profileButtonTapped(){
        if let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}
