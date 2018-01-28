//
//  SecondViewController.swift
//  segue delegates
//
//  Created by Christopher Hynes on 2018-01-23.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit

protocol CanReceive {           //step 1 create a protocol with a method to conform to in step 2
    func dataReceived(data : String, newCount: Int, addedArray: [Int])
}


class SecondViewController: UIViewController {
    var data = ""
    var thisArray : [Int] = []
    var  count = 0
    
    @IBOutlet weak var arrayLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textBox: UITextField!
    
    var delegate : CanReceive?  //this created the delegate here dont forget
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count += 1
        thisArray.append(count)
        arrayLabel.text = String(describing: thisArray)
        textLabel.text = data
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendButton(_ sender: UIButton) {
        delegate?.dataReceived(data: textBox.text!, newCount: count, addedArray: thisArray)    //optional delegate set to protocol method set in step 1
        dismiss(animated: true, completion: nil)     //dismiss the current UIViewController
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
