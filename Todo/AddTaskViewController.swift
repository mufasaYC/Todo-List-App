//
//  AddTaskViewController.swift
//  Todo
//
//  Created by Mustafa Yusuf on 25/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddTaskViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

	@IBOutlet weak var segmentView: UISegmentedControl!
	@IBOutlet weak var taskTV: UITextView!
	
	var priority = "!!!"
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		monthView.delegate = self
		monthView.dataSource = self
		dateView.delegate = self
		dateView.dataSource = self
		monthView.type = .linear
		monthView.reloadData()
		dateView.type = .linear
		dateView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func segment(_ sender: Any) {
		if segmentView.selectedSegmentIndex == 0{
			priority = "!!!"
		} else if segmentView.selectedSegmentIndex == 1{
			priority = "!!"
		} else if segmentView.selectedSegmentIndex == 2{
			priority = "!"
		}
		
		
	}
    
	@IBAction func done(_ sender: Any) {
		if taskTV.text == "" {
			return
		}
		
		let date = Date()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "dd-MM-yyyy"
		let day = "\(formatter.string(from: date))"
		formatter.dateFormat = "HH:mm"
		let time = "\(formatter.string(from: date))"
		
		FIRDatabase.database().reference().child("task").child("\(username)").childByAutoId().updateChildValues(["title":"\(taskTV.text!)","priority":"\(priority)","date": day, "time": time, "completed": false,"month": (monthView.currentItemView as! UITextView).text!,"com_date":(dateView.currentItemView as! UITextView).text! ])
		self.navigationController?.popToRootViewController(animated: true)
	}

	@IBOutlet weak var dateView: iCarousel!
	@IBOutlet weak var monthView: iCarousel!
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		if monthView == carousel {
			return 12
		}
		return 30
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		var itemView: UITextView
		if (view == nil) {
			itemView = UITextView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
			itemView.isEditable = false
			itemView.isSelectable = false
			itemView.isScrollEnabled = false
			itemView.textAlignment = .center
			itemView.backgroundColor = UIColor.clear
		}
		else {
			itemView = view as! UITextView;
		}
		if carousel == monthView {
			itemView.text = month[index]
		} else {
			itemView.text = "\(index+1)"
		}
		
		return itemView
	}
	
	var month = ["JAN","FEB","MAR","APR","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
