//
//  LoginViewController.swift
//  UserFlow
//
//  Created by Yogesh Patel on 08/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton){
        
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        let users = DatabaseHelper.shareInstance.getAllUsers()
        let filterUsers = users.filter{
            $0.email == email && $0.password == password
        }
        
        if filterUsers.count > 0{
            if let user = filterUsers.first{
                if let userEmail = user.email{
                    UserDefaults.standard.set(userEmail, forKey: "emailKey")
                    //print(UserDefaults.standard.value(forKey: "emailKey"))
                    
                    let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
                    if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
                        window?.rootViewController = homeNavigationController
                        window?.makeKeyAndVisible()
                    }
                }
            }
        }else{
            print("User not found")
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton){
        if let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController{
            signupViewController.isSignup = true
            self.navigationController?.pushViewController(signupViewController, animated: true)
        }
    }
    
}

//DO Email, password - validation and empty condition

/*
 let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
 if let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController{
     let navigationController = UINavigationController(rootViewController: homeViewController)
     window?.rootViewController = navigationController
     window?.makeKeyAndVisible()
 }
 */
