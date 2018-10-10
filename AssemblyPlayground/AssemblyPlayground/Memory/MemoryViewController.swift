//
//  MemoryViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 16.09.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class MemoryViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var tableViewDataSource = MemoryTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
    }
    
    func updateMemory() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
