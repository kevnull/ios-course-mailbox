//
//  MailboxViewController.swift
//  ios-course-mailbox
//
//  Created by Kevin Cheng on 9/15/14.
//  Copyright (c) 2014 Kevin Cheng. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgba: String) {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index = advance(rgba.startIndex, 1)
            let hex = rgba.substringFromIndex(index)
            let scanner = NSScanner.scannerWithString(hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if countElements(hex) == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if countElements(hex) == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                println("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    var originalCenter : CGPoint!
    var menuHidden : Bool = true
    var canUndo : Bool = false
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var composeContainer: UIView!
    @IBOutlet weak var newMessageNav: UIImageView!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var helpView: UIImageView!
    @IBOutlet weak var searchView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var navSegment: UISegmentedControl!
    @IBOutlet weak var navView: UIImageView!

    @IBAction func onCancelButton(sender: AnyObject) {
        UIView.animateWithDuration(0.3,  animations: { () -> Void in
            self.screenView.alpha = 0
            self.composeContainer.frame.origin.y = 747
            self.newMessageNav.frame.origin.x = 320
            self.newMessageNav.alpha = 0
            self.cancelButton.frame.origin.x = 328
            }, completion: nil)
        view.endEditing(true)
        
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toText: UITextField!
    @IBAction func onComposeButton(sender: AnyObject) {
        UIView.animateWithDuration(0.3,  animations: { () -> Void in
            self.screenView.alpha = 0.6
            self.composeContainer.frame.origin.y = 80
            self.newMessageNav.frame.origin.x = 0
            self.newMessageNav.alpha = 1
            self.cancelButton.frame.origin.x = 8
            }, completion: nil)
        toText.becomeFirstResponder()
    }
    
    @IBAction func onNav(sender: AnyObject) {
        switch (navSegment.selectedSegmentIndex) {
        case 0:
            navSegment.tintColor = UIColor (rgba: "#F5CC4E")
            composeButton.tintColor = UIColor (rgba: "#F5CC4E")
            menuButton.tintColor = UIColor (rgba: "#F5CC4E")
        case 1:
            navSegment.tintColor = UIColor (rgba: "#5BB7D7")
            composeButton.tintColor = UIColor (rgba: "#5BB7D7")
            menuButton.tintColor = UIColor (rgba: "#5BB7D7")
            UIView.animateWithDuration(0.4,  delay: 0.2, options: nil, animations: { () -> Void in
                self.scrollView.frame.origin.x = 0
                self.archiveScrollView.frame.origin.x = 320
                }, completion: nil)
        case 2:
            navSegment.tintColor = UIColor (rgba: "#90D062")
            composeButton.tintColor = UIColor (rgba: "#90D062")
            menuButton.tintColor = UIColor (rgba: "#90D062")
            UIView.animateWithDuration(0.4,  delay: 0.2, options: nil, animations: { () -> Void in
                self.scrollView.frame.origin.x = -320
                self.archiveScrollView.frame.origin.x = 0
                }, completion: nil)
        default:
            break
        }
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    //do stuff
        if (segue.identifier == "scheduledSegue") {
            UIView.animateWithDuration(0.4,  delay: 0.2, options: nil, animations: { () -> Void in
                self.messageContainerView.frame.origin.y -= self.messageView.frame.size.height
                self.feedView.frame.origin.y -= self.messageView.frame.size.height
                }, completion: nil)
            canUndo = true
        } else if (segue.identifier == "dismissScheduleSegue") {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.messageView.frame.origin.x = 0
                self.iconView.frame.origin.x = 320 - self.iconView.frame.size.width - 20
                }, completion: nil)
        }
    }

    // given scale of x to y, find where value fits on scale of a to b
    func transformValue (value : Float, x : Float, y : Float, a : Float, b: Float) -> Float {
        return (value/(y-x)*(b-a))+a
    }
   
    @IBAction func onMenuButton(sender: AnyObject) {
        if (menuHidden) {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.containerView.frame.origin.x = 285
                }, completion: nil)
            menuHidden = false
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.containerView.frame.origin.x = 0
                }, completion: nil)
            menuHidden = true
        }
    }
    
    @IBAction func onEdgePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var translation = gestureRecognizer.translationInView(view)
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: view, action: "onEdgePan:")

        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            originalCenter = containerView.center
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
            println("got here \(menuHidden)")
            if (menuHidden) {
                containerView.center.x = originalCenter.x + translation.x
            } else {
                containerView.center.x = originalCenter.x - translation.x
                println(translation.x)
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            if (menuHidden && translation.x > 90) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.containerView.frame.origin.x = 285
                    }, completion: nil)
                menuHidden = false
                edgeGesture.edges = UIRectEdge.Right
            } else if (menuHidden) {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.containerView.frame.origin.x = 0
                }, completion: nil)
            } else if (translation.x < -90) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.containerView.frame.origin.x = 285
                    }, completion: nil)
            } else {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.containerView.frame.origin.x = 0
                    }, completion: nil)
                menuHidden = true
                edgeGesture.edges = UIRectEdge.Left
            }
            println(menuHidden)
        }
    }
    
    @IBAction func onMessagePan(gestureRecognizer : UIPanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var x : CGFloat = messageView.frame.origin.x
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            originalCenter = messageView.center
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
            
            messageView.center.x = originalCenter.x + translation.x

            iconView.alpha = 1
            if (x >= 0) {
                iconView.frame.origin.x = x - iconView.frame.size.width - 15
            } else {
                println(x + messageView.frame.size.width + 40)
                iconView.frame.origin.x = x + messageView.frame.size.width + 15
            }
//            println(x)
            switch (x) {
            case (-320)...(-260): // drag far left (list)
                messageContainerView.backgroundColor = UIColor (rgba: "#CBA67E")
                iconView.image = UIImage (named: "list_icon")
            case (-260)...(-60): // drag left (schedule)
                messageContainerView.backgroundColor = UIColor (rgba: "#F5CC4E")
                iconView.image = UIImage (named: "later_icon")
            case (-60)...0: // drag left slightly
                iconView.frame.origin.x = 300 - iconView.frame.size.width
                iconView.alpha = CGFloat(transformValue(Float(x), x: 60, y: 0, a: 0, b: 1))
                messageContainerView.backgroundColor = UIColor (rgba: "#e5e5e5")
                iconView.image = UIImage (named: "later_icon")
            case 0...60: // drag right slightly
                iconView.frame.origin.x = 20
                iconView.alpha = CGFloat(transformValue(Float(x), x: 0, y: 60, a: 0, b: 1))
                messageContainerView.backgroundColor = UIColor (rgba: "#e5e5e5")
                iconView.image = UIImage (named: "archive_icon")
            case 60...260: // drag right (archive)
                messageContainerView.backgroundColor = UIColor (rgba: "#90D062")
                iconView.image = UIImage (named: "archive_icon")
            case 260...320: // drag far right (delete)
                messageContainerView.backgroundColor = UIColor (rgba: "#CD6A41")
                iconView.image = UIImage (named: "delete_icon")
            default:
                break
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
            switch (x) {
            case (-320)...(-260): // drag far left (list)
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.frame.origin.x = CGFloat(0 - self.messageView.frame.size.width - self.iconView.frame.size.width - 15)
                    self.iconView.frame.origin.x = 0 - self.iconView.frame.size.width
                    }, completion: { (Bool) -> Void in
                        self.performSegueWithIdentifier("listSegue", sender: self)
                })
            case (-260)...(-60): // drag left (schedule)
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.frame.origin.x = CGFloat(0 - self.messageView.frame.size.width - self.iconView.frame.size.width - 15)
                    self.iconView.frame.origin.x = 0 - self.iconView.frame.size.width
                    }, completion: { (Bool) -> Void in
                        self.performSegueWithIdentifier("scheduleSegue", sender: self)
                })
            case (-60)...60: // drag left or right slightly
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    self.iconView.alpha = 0
                    }, completion: nil)
            case 60...320: // drag right
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.frame.origin.x = CGFloat(320 + self.iconView.frame.size.width + 15)
                    self.iconView.frame.origin.x = 320
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.4,  delay: 0.2, options: nil, animations: { () -> Void in
                            self.messageContainerView.frame.origin.y -= self.messageView.frame.size.height
                            self.feedView.frame.origin.y -= self.messageView.frame.size.height
                            }, completion: nil)
                })
                canUndo = true
            default:
                break
            }
            
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (canUndo) {
            self.messageView.frame.origin.x = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.messageContainerView.frame.origin.y += self.messageView.frame.size.height
                self.feedView.frame.origin.y += self.messageView.frame.size.height
                }, completion: nil)
            canUndo = false
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.contentSize.width = feedView.frame.width
        scrollView.contentSize.height = feedView.frame.height + helpView.frame.height + searchView.frame.height
        scrollView.contentOffset.y = 79

        archiveScrollView.delegate = self
        archiveScrollView.contentSize.width = feedView.frame.width
        archiveScrollView.contentSize.height = feedView.frame.height +  searchView.frame.height
        archiveScrollView.contentOffset.y = 42
        archiveScrollView.frame.origin = CGPoint(x: 320, y:0)
println(archiveScrollView.frame)
println(archiveScrollView.contentSize)
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        containerView.addGestureRecognizer(edgeGesture)
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
