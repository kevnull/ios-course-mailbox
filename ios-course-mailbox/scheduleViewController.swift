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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
