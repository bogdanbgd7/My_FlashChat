//
//  RegisterViewController.swift
//  My_Flash_Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth
//import SVProgressHUD

class RegisterViewController: UIViewController {

    
    

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        //SVProgressHUD.show()
        

        
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error ) in
            if error != nil {
                print(error!)
            }
            else {
                print("REGISTRATION SUCCESSFUL!")
                
               // SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        

        
        
    } 
    
    
}
