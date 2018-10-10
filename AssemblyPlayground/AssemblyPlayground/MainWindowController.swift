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
    
    var splitViewController: SplitViewController {
        get {
            return self.contentViewController as! SplitViewController
        }
    }
    
    var displayWindowController: DisplayWindowController?
    
    /// The holy Engine:
    var engine: Engine!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        splitViewController.segmentedControl = segmentedControl
    }
    
    func setupEngine(emulationMode: EmulationMode) {
        self.engine = Engine(emulationMode: emulationMode)
        self.engine.delegate = self
    }
    
    @IBAction func run(_ sender: NSButton) {
        guard let codeVC = splitViewController.codeItem.viewController as? CodeEditorViewController else { return }
        
        if engine.prepareCode(codeVC.assembly) {
            engine.run()
        }
    }
    
    @IBAction func reset(_ sender: NSButton) {
        setupEngine(emulationMode: engine.emulationMode)
        // give display the new pointer
        if let displayVC = displayWindowController?.contentViewController as? DisplayViewController {
            displayVC.setMemory(pointer: engine.memory)
        }
        // update everything
        executionFinished()
    }
    
    @IBAction func showDisplayViewController(sender: NSButton) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let displayWC = displayWindowController {
            displayWC.window?.makeKeyAndOrderFront(self)
        } else {
            displayWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DisplayWindowController")) as? DisplayWindowController
            displayWindowController?.window?.makeKeyAndOrderFront(self)
            if let displayVC = displayWindowController?.contentViewController as? DisplayViewController {
                displayVC.setMemory(pointer: engine.memory)
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: NSSegmentedControl) {
        if let splitViewController = contentViewController as? SplitViewController {
            splitViewController.setCollapsedState()
        }
    }
}

extension MainWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        displayWindowController?.close()
        displayWindowController = nil
    }
}

extension MainWindowController: EngineDelegate {
    
    func executionFinished() {
        if let displayWindowController = self.displayWindowController {
            DispatchQueue.main.async {
                displayWindowController.display?.setNeedsDisplay(displayWindowController.display!.bounds)
            }
        }
        (self.splitViewController.registerItem.viewController as? RegisterTableViewController)?.updateRegisters()
        (self.splitViewController.memoryItem.viewController as? MemoryViewController)?.updateMemory()
    }
    
}
