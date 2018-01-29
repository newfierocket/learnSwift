//
//  LoginViewController.swift
//  Clockin
//
//  Created by Christopher Hynes on 2018-01-27.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SCLAlertView

class LoginViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    
    @IBOutlet weak var passwordLoginTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailLoginTextField.text!, password: passwordLoginTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                SCLAlertView().showError("There was an Error", subTitle: "Please try again")
            } else {
                print("User Authenticated")
                self.performSegue(withIdentifier: "goToClockin", sender: self)
                SVProgressHUD.dismiss()
            }
            
        }
        
        
    }
    
   
}
