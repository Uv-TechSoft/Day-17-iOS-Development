//
//  ProfileViewController.swift
//  UserFlow
//
//  Created by Yogesh Patel on 18/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var currentUser: User?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        configuration()
    }
        
}

// MARK: - Helper Method
extension ProfileViewController{
    
    func configuration(){
        let profileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        //profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageViewTapGesture)
        
        uiConfiguration()
        getUserDetails()
    }
    
    func uiConfiguration(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    func getUserDetails(){
        if let email = UserDefaults.standard.string(forKey: "emailKey"){
            let filterUser = DatabaseHelper.shareInstance.getAllUsers().filter{
                $0.email == email
            }.first
            if let currentUser = filterUser{
                
                self.currentUser = currentUser
                
                firstnameField.text = currentUser.firstname
                lastnameField.text = currentUser.lastname
                emailField.text = currentUser.email
                passwordField.text = currentUser.password
                
                let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let fileURL = documentURL?.appendingPathComponent(currentUser.profileImageName ?? "").appendingPathExtension("png")
                
                profileImageView.image = UIImage(contentsOfFile: fileURL?.path ?? "")
            }
        }
    }
    
    @objc
    func profileImageTapped(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true)
    }
}

// MARK: - Actions
extension ProfileViewController{
    
    @IBAction func updateButtonTapped(_ sender: UIButton){
        
        let tempImage = UIImage(systemName: "person.circle.fill")
                
        guard let firstname = firstnameField.text, !firstname.isEmpty else {
            showAlert(message: "please enter your firstname")
            return
        }
        guard let lastname = lastnameField.text, !lastname.isEmpty else {
            showAlert(message: "please enter your lastname")
            return
        }
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(message: "please enter your email address")
            return
        }
        
        if !isValidEmail(email){
            showAlert(message: "Please enter your valid email address.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "please enter your password")
            return
        }
        
        if !isValidPassword(password){
            showAlert(message: "Please enter your valid password.")
            return
        }
        
        if profileImageView.image?.pngData() == tempImage?.pngData(){
            showAlert(message: "Please choose your profile Image.")
            return
        }
        
        if let currentUser = currentUser{
            let userModel = UserModel(firstname: firstname, lastname: lastname, email: email, password: password, profileImageName: currentUser.profileImageName ?? "")
            
            saveProfileImage(fileName: currentUser.profileImageName ?? "")
            
            DatabaseHelper.shareInstance.updateUser(currentUser: currentUser, userModel: userModel)
        }
        
    }
    
    func saveProfileImage(fileName: String){
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
       // print(documentURL)//Document URL
        
        let fileURL =  documentURL?.appendingPathComponent(fileName).appendingPathExtension("png")
      //  print(fileURL)//Final URL (Name and Extension add kiya hai
        
        if let imageData = profileImageView.image?.pngData(), let url = fileURL{
            do {
                try imageData.write(to: url)//Write ka code - save kar raha hai document mai
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else{
            return
        }
        profileImageView.image = selectedImage
    }
}

extension ProfileViewController{
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: password)
    }
    //"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),}$"
    //1 number 1 alphabet total 8 character
}
///https://stackoverflow.com/questions/29666956/validation-of-email-in-swift-ios-application/53441176
///https://stackoverflow.com/questions/39284607/how-to-implement-a-regex-for-password-validation-in-swift

/*
 
 
 if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
     let register = User(context: context)
     register.firstname = firstname
     register.lastname = lastname
     register.email = email
     register.password = password
     register.profileImageName = fileName
     do {
         try context.save()
     } catch let error {
         print(error.localizedDescription)
     }
     
 }
 */
