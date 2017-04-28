//
//  ListViewController.swift
//  Todo
//
//  Created by Mustafa Yusuf on 25/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var tasks = [NSDictionary]()
	var ids = [String]()
	var cids = [String]()
	var completed = [NSDictionary]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		tableView.delegate = self
		tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		fetchData()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1 {
			return completed.count
		}
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
		if indexPath.section == 1 {
			cell.listLabel.text = "\(completed[indexPath.row]["title"]!)"
			cell.backView.backgroundColor = UIColor.lightGray
			cell.timeLabel.text = "\(completed[indexPath.row]["date"]!)  \(completed[indexPath.row]["time"]!)"
			return cell
		}
		cell.completionLabel.text = "\(tasks[indexPath.row]["com_date"]!)  \(tasks[indexPath.row]["month"]!)"
		cell.listLabel.text = "\(tasks[indexPath.row]["title"]!)"
		cell.backView.backgroundColor = color(x :"\(tasks[indexPath.row]["priority"]!)")
		cell.timeLabel.text = "\(tasks[indexPath.row]["date"]!)  \(tasks[indexPath.row]["time"]!)"
		
		return cell
	}
	
	func color(x: String) -> UIColor {
		if x == "!!!" {
			return UIColor.red
		} else if x == "!!" {
			return UIColor.yellow
		} else if x == "!" {
			return UIColor.white
		}
		return UIColor.white
	}
	
	var priority = [NSDictionary]()
	
	func sorter() {
	}
	
	func fetchData() {
		FIRDatabase.database().reference().child("task").child("\(username)").observe(.value, with: {snapshot in
		
			self.tasks.removeAll()
			self.ids.removeAll()
			self.cids.removeAll()
			self.completed.removeAll()
			let snaps = snapshot.children.allObjects as! [FIRDataSnapshot]
			
			for snap in snaps {
				
				if (snap.value as! NSDictionary)["completed"] as! Bool == false {
					self.ids.append(snap.key)
					self.tasks.append(snap.value as! NSDictionary)
				} else {
					self.cids.append(snap.key)
					self.completed.append(snap.value as! NSDictionary)
				}
				if snap == snaps.last {
					self.tableView.reloadData()
				}
			}
		})
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Completed Tasks"
		}
		return "Pending Tasks"
	}

	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		if indexPath.section == 1 {
			let rowAction2 = UITableViewRowAction(style: .destructive, title: "Delete", handler: {x,index in
				self.tasks.remove(at: indexPath.row)
				FIRDatabase.database().reference().child("task").child("\(username)").child("\(self.cids[indexPath.row])").removeValue()
				self.ids.remove(at: indexPath.row)
				tableView.reloadData()
			})
			rowAction2.backgroundColor = UIColor.red
			return [rowAction2]
		}
		let rowAction1 = UITableViewRowAction(style: .destructive, title: "Completed", handler: {x,index in
			FIRDatabase.database().reference().child("task").child("\(username)").child("\(self.ids[indexPath.row])").child("completed").setValue(true)
			})
			rowAction1.backgroundColor = UIColor.darkGray
		let rowAction2 = UITableViewRowAction(style: .destructive, title: "Delete", handler: {x,index in
			self.tasks.remove(at: indexPath.row)
			FIRDatabase.database().reference().child("task").child("\(username)").child("\(self.ids[indexPath.row])").removeValue()
			self.ids.remove(at: indexPath.row)
			tableView.reloadData()

		})
			rowAction2.backgroundColor = UIColor.red
		return [rowAction1, rowAction2]
	}

	
	
}
