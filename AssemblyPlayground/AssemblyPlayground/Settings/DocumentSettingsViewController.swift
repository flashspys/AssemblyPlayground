//
//  DocumentSettingsViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class DocumentSettingsViewController: NSViewController {

    @IBOutlet weak var emulationModePopUp: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let document = Document.current {
            emulationModePopUp.selectItem(at: Int(document.data.emulationMode.rawValue))
        }
    }
    
    @IBAction func emulationModeChanged(_ sender: NSPopUpButton) {
        if let document = Document.current,
            let emulationMode = EmulationMode(rawValue: Int32(sender.indexOfSelectedItem)) {
            document.changeEmulationMode(to: emulationMode)
        }
    }
}
