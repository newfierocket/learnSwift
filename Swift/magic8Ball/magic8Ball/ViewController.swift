//
//  ViewController.swift
//  magic8Ball
//
//  Created by Christopher Hynes on 2018-01-18.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var magic8ballImageNumber: Int = 0
    let imageArray = ["ball1", "ball2", "ball3", "ball4", "ball5"]

    @IBOutlet weak var magicBallImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func change8BallImage() {
        magic8ballImageNumber = Int(arc4random_uniform(5))
        magicBallImage.image = UIImage(named: imageArray[magic8ballImageNumber])
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        change8BallImage()
    }
    

    @IBAction func askMeButton(_ sender: UIButton) {
        change8BallImage()
    }
    
}

