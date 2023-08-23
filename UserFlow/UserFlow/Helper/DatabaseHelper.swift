//
//  DatabaseHelper.swift
//  UserFlow
//
//  Created by Yogesh Patel on 12/11/21.
//

import UIKit
import CoreData

///Singleton Class - CRUD (Design Pattern)

class DatabaseHelper{
    
   static let shareInstance = DatabaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveUser(userModel: UserModel){
        if let context = context{
            let user = User(context: context)
            user.firstname = userModel.firstname
            user.lastname = userModel.lastname
            user.email = userModel.email
            user.password = userModel.password
            user.profileImageName = userModel.profileImageName
            
            saveContext()
        }
    }
    
    //Set<String>
    func getAllUsers() -> [User]{
        var userArray = [User]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            userArray = try context?.fetch(fetchRequest) as? [User] ?? []           
        } catch  {
            print(error.localizedDescription)
        }
        
        return userArray
    }
    
    func updateUser(currentUser: User, userModel: UserModel){
        currentUser.firstname = userModel.firstname
        currentUser.lastname = userModel.lastname
        currentUser.email = userModel.email
        currentUser.password = userModel.password
        currentUser.profileImageName = userModel.profileImageName
        
        saveContext()
    }
    
    func deleteUser(user: User){
        context?.delete(user)
        saveContext()
    }
    
    func saveContext(){
        if let context = context{
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
