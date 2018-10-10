//
//  MemoryTableViewDataSource.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 16.09.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class MemoryTableViewDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (Engine.current?.memorySize ?? 0) / 8
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let engine = Engine.current {
            
            let address: UInt64 = UInt64(row) * 8
            
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "Address") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AddressCell"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = address.toHexaString
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "AddressValue") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AddressValueCell"), owner: nil) as? NSTableCellView
                let string = engine.unicorn.readMemory(addr: address, size: 8)
                    .map({ ($0 <= 0xf ? "0" : "") + String($0, radix: 16)})
                    .joined(separator: "\u{2009}")
                let attributedString = NSMutableAttributedString(string: string, attributes: [
                    .font: NSFont(name: "Fira Code", size: 13) as Any
                ])
                for location in stride(from: 2, to: 23, by: 3) {
                    attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13), range: NSRange(location: location, length: 1))
                }
                
                cell?.textField?.attributedStringValue = attributedString
                cell?.textField?.isEditable = true
                cell?.textField?.font = NSFont(name: "Fira Code", size: 13)
                return cell
            }
        }
        return nil
    }
    
}
