//
//  MainWindowController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    var displayWindowController: DisplayWindowController?
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let splitViewController = contentViewController as? SplitViewController {
            splitViewController.segmentedControl = segmentedControl
        }
    }
    
    @IBAction func showDisplayViewController(sender: NSButton) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let displayWC = displayWindowController {
            displayWC.window?.makeKeyAndOrderFront(self)
        } else {
            displayWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DisplayWindowController")) as? DisplayWindowController
            
            displayWindowController?.window?.makeKeyAndOrderFront(self)
        }
        /*
        displayWindow = windowController.contentViewController as? DisplayViewController
        displayWindow!.setMemory(pointer!)
        display = self.displayWindow!.view.subviews[0] as? Display*/
    }
    
    @IBAction func segmentedControlChanged(_ sender: NSSegmentedControl) {
        if let splitViewController = contentViewController as? SplitViewController {
            splitViewController.setCollapsedState()
        }
    }
}
