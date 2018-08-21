//
//  MainWindowController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func showDisplayViewController(sender: NSButton) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DisplayWindowController")) as! NSWindowController
        if let window = windowController.window {
            NSApp.runModal(for: window)
        }
        
        /*
        displayWindow = windowController.contentViewController as? DisplayViewController
        displayWindow!.setMemory(pointer!)
        display = self.displayWindow!.view.subviews[0] as? Display*/
    }
}
