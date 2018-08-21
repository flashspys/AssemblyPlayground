//
//  DisplayViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

class DisplayViewController: NSViewController {
    
    @IBOutlet var display: Display!

    func setMemory(pointer: UnsafeMutablePointer<UInt8>) {
        self.display.initMemory(pointer)
    }
    
}
