//
//  scheduleViewController.swift
//  ios-course-mailbox
//
//  Created by Kevin Cheng on 9/17/14.
//  Copyright (c) 2014 Kevin Cheng. All rights reserved.
//

import UIKit

class scheduleViewController: UIViewController {


    @IBAction func scheduleTap(sender: AnyObject) {
       // schedule
        performSegueWithIdentifier("scheduledSegue", sender: self)
    }
    
    @IBAction func dismissTap(sender: AnyObject) {
        performSegueWithIdentifier("dismissScheduleSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
