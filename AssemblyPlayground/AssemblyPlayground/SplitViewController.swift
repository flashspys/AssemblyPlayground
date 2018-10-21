//
//  SplitViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    weak var segmentedControl: NSSegmentedControl?
    
    @IBOutlet weak var codeItem: NSSplitViewItem!
    @IBOutlet weak var registerItem: NSSplitViewItem!
    @IBOutlet weak var memoryItem: NSSplitViewItem!
    @IBOutlet weak var settingsItem: NSSplitViewItem!
    
    var codeViewController: CodeEditorViewController? {
        return codeItem.viewController as? CodeEditorViewController
    }
    
    var registerViewController: RegisterTableViewController? {
        return registerItem.viewController as? RegisterTableViewController
    }
    
    var memoryViewController: MemoryViewController? {
        return memoryItem.viewController as? MemoryViewController
    }
    
    var settingsViewController: DocumentSettingsViewController? {
        return settingsItem.viewController as? DocumentSettingsViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeItem.minimumThickness = 100 // Code
        self.registerItem.minimumThickness = 243 // Registers
        self.memoryItem.minimumThickness = 100 // Memory
        self.settingsItem.minimumThickness = 100 // Settings
    }
    
    func setCollapsedState() {
        if let segmentedControl = segmentedControl {
            for (index, item) in self.splitViewItems[1...].enumerated() {
                item.isCollapsed = !segmentedControl.isSelected(forSegment: index)
            }
        }
    }
    
    /// If the view gets collapsed, update the segmentedControl repectively
    override func splitViewDidResizeSubviews(_ notification: Notification) {
        if let segmentedControl = segmentedControl {
            for (index, item) in self.splitViewItems[1...].enumerated() {
                segmentedControl.setSelected(!item.isCollapsed, forSegment: index)
            }
        }
    }
    
}
