//
//  RegisterTableViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class RegisterTableViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateRegisters() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension RegisterTableViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let engine = Engine.current {
        
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "Register") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RegisterCell"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = engine.emulationMode.inspectableRegisters()[row].description
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "Value") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = engine.emulationMode.inspectableRegisters()[row].value(with: engine).hexStr(min: 16)
                cell?.textField?.isEditable = true
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            }
        }
        return nil
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Engine.current?.emulationMode.inspectableRegisters().count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}
