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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
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
