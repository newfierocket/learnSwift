//
//  RegisterViewController.swift
//  Clockin
//
//  Created by Christopher Hynes on 2018-01-27.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SCLAlertView

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
    
    
    SVProgressHUD.show()
    
    Auth.auth().createUser(withEmail: emailTextBox.text!, password: passwordTextBox.text!) { (user, error) in
    
    if error != nil {
    print(error!)
        SVProgressHUD.dismiss()
        SCLAlertView().showError("Something Went Wrong!", subTitle: "Please Try again.")
    } else {
    //sucess
    print("Success")
    self.performSegue(withIdentifier: "goToClockin", sender: self)
    SVProgressHUD.dismiss()
    }
    }
    }

}
