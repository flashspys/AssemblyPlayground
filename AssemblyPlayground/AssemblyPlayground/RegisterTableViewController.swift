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
                cell?.textField?.stringValue = InspectableRegisters.X86.allCases[row].rawValue
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "Value") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = engine.unicorn.readRegister(InspectableRegisters.X86.allCases[row]).hexStr(min: 16)
                cell?.textField?.isEditable = true
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            }
        }
        return nil
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let emulationMode = Engine.current?.emulationMode {
            switch emulationMode {
            case .x86:
                return InspectableRegisters.X86.allCases.count
            case .arm64:
                return InspectableRegisters.ARM64.allCases.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}
