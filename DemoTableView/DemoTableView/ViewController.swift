//
//  ViewController.swift
//  DemoTableView
//
//  Created by yosemite on 28/01/15.
//  Copyright (c) 2015 yosemite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableData = [" ","Uno", "Dos", "Tres"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView (tableView: UITableView!, numberOfRowsInSection section: Int ) -> Int {
        return self.tableData.count;
    }
    
    
    func tableView (tableView: UITableView!,
        cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
        cell.textLabel?.text=tableData[indexPath.row]
        return cell
    }
    
    
}

