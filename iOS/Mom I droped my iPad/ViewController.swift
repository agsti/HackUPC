//
//  ViewController.swift
//  Mom I droped my iPad
//
//  Created by Victor Gallego Betorz on 20/2/16.
//  Copyright © 2016 Victor Gallego Betorz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func start(sender: AnyObject)
    {
        Save.string("name", nameText.text!)
        performSegueWithIdentifier("startGameSegue", sender:self)
    }
    
    class Load {
        class func string(key:String) -> String! {
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        }
    }
    
    class Save {
        class func string(key:String, _ value:String) {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = Load.string("name")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

