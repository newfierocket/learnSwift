//
//  ViewController.swift
//  segue delegates
//
//  Created by Christopher Hynes on 2018-01-23.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CanReceive { //step 2 Conform ########

    var myArray : [Int] = [1]
    var count = 1
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func button(_ sender: UIButton) {
        
        performSegue(withIdentifier: "sendDataForwards", sender: self) // preforms the segue to new SecondViewController
        
        
    }
    
    //##############################################
    //MARK: Beginning of sending data across view controller using segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataForwards" {
            
            let secondVC = segue.destination as! SecondViewController
            secondVC.data = textBox.text!
            secondVC.thisArray = myArray
            secondVC.count = count
            textBox.placeholder = "Enter Text to Send.."
            secondVC.delegate = self   //need to set secondVC constant to self to be delegate
        }
    }

    func dataReceived(data: String, newCount: Int, addedArray: [Int]) {   //part of conforming. this function is created in protocol in SecondViewController
        textLabel.text = data
        count = newCount
        myArray = addedArray
        myArray.append(count)
        
        countLabel.text = String(describing: myArray)
    }

}

