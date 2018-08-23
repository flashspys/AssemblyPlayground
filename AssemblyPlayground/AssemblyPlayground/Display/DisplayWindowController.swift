//
//  DisplayWindowController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import AppKit

class DisplayWindowController: NSWindowController {
    
    var display: Display? {
        get {
            return (self.contentViewController as? DisplayViewController)?.display
        }
    }
    
    override func windowDidLoad() {
        window?.delegate = self
        window?.level = .modalPanel
    }
}

extension DisplayWindowController: NSWindowDelegate {

    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
    
}
