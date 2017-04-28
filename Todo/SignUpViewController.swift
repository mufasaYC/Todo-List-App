//
//  SignUpViewController.swift
//  Todo
//
//  Created by Mustafa Yusuf on 25/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController {

	@IBOutlet weak var cpasswordTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	@IBOutlet weak var usernameTF: UITextField!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	@IBOutlet weak var ratioConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
	var keyboardHeight = CGFloat()
	var duration = TimeInterval()
	var flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		activity.isHidden = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
    }
	
	
	func keyboardWillHide(_ notification: Notification) {
		if flag%2 == 1 {
			self.ratioConstraint.constant = 0
			self.bottomConstraint.constant -= (self.keyboardHeight - 10)
			flag = 0
			UIView.animate(withDuration: duration, animations: {Void in
				self.view.layoutIfNeeded()
			})
			
		}
		
	}
	
	
	func keyboardWillShow(_ notification:Notification) {
		if flag == 0 {
			let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
			let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
			let keyboardRectangle = keyboardFrame.cgRectValue
			keyboardHeight = keyboardRectangle.height
			duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
			
		}
		if flag%2 == 0 {
			flag += 1
			self.bottomConstraint.constant += (self.keyboardHeight - 10)
			self.ratioConstraint.constant = 150
			UIView.animate(withDuration: duration, animations: {Void in
				self.view.layoutIfNeeded()
			})
		}
		
		
	}
	
	@IBAction func signUpBtn(_ sender: Any) {
		signup()
	}
	
	func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func signup() {
		
		if passwordTF.text == "" || usernameTF.text == "" {
			return
		}
		
		if passwordTF.text != cpasswordTF.text {
			//DIFFERNT PASSWORDS
			return
		}
		
		activity.isHidden = false
		activity.startAnimating()
		FIRDatabase.database().reference().child("users").observe(.value, with: {snapshot in
			
			let snaps = snapshot.children.allObjects as! [FIRDataSnapshot]
			
			for snap in snaps {
				if snap.key == "\(self.usernameTF.text!)" {
					self.existingUser()
					self.activity.stopAnimating()
					self.activity.isHidden = true
					return
				}
				if snap == snaps.last {
					self.signUserUp()
				}
			}
		})
	}
	
	func signUserUp() {
		username = usernameTF.text!
		FIRDatabase.database().reference().child("users").updateChildValues(["\(usernameTF.text!)" : "\(passwordTF.text!)"])
		activity.stopAnimating()
		activity.isHidden = true
		performSegue(withIdentifier: "success", sender: self)
	}
	
	func existingUser() {
		
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
