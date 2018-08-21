//
//  ViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 10.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

extension String {
    var drop0xPrefix: String {
        return hasPrefix("0x") ? String(self.dropFirst(2)) : self
    }
    
    var hexaToDecimal: UInt64 {
        return UInt64(drop0xPrefix, radix: 16) ?? 0
    }
}

extension UInt64 {
    var toHexaString: String {
        return "0x"+String(self, radix: 16)
    }
    
    func hexStr(min: Int) -> String {
        var str = self.toHexaString.drop0xPrefix
        while str.count < min {
            str = "0" + str
        }
        return "0x" + str
    }
}

class ViewController: NSViewController {
    
    @objc var rax: String = "0x0000000000000000"
    @objc var rbx: String = "0x0000000000000000"
    @objc var rcx: String = "0x0000000000000000"
    @objc var rdx: String = "0x0000000000000000"
    
    @objc var code = NSAttributedString(string: "inc eax\ninc ebx")
    
    weak var displayWindow: DisplayViewController?
    weak var display: Display?
    
    let uni = Unicorn()
    let ks = Keystone()
    
    @IBOutlet var codeEditor: SourceTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeEditor.keywordColors = ["inc": NSColor.red]
        
        uni.delegate = self
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024*1024)
        uni.createMemory(withPointer: pointer, size: 1024*1024)
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Display")) as! NSWindowController
        windowController.showWindow(self)
        displayWindow = windowController.contentViewController as? DisplayViewController
        displayWindow!.setMemory(pointer: pointer)
        display = self.displayWindow!.view.subviews[0] as? Display
    }
    
    
    @IBAction func run(_ sender: NSButton) {
        self.view.window?.endEditing(for: nil)
        let opcode = ks.assemble(string: code.string)
        uni.writeCode(code: opcode)
        
        uni.setRegister(.RAX, toValue: rax.hexaToDecimal)
        uni.setRegister(.RBX, toValue: rbx.hexaToDecimal)
        uni.setRegister(.RCX, toValue: rcx.hexaToDecimal)
        uni.setRegister(.RDX, toValue: rdx.hexaToDecimal)
        
        uni.run()
        
    }
    
}

extension ViewController: UnicornDelegate {
    func updateDisplay() {
        DispatchQueue.main.async {
            self.display!.setNeedsDisplay(self.display!.bounds)
        }
    }
    
    func memoryWrite(to address: Int64, value: Int64, size: Int) {
        updateDisplay()
    }
    
    func instructionExecuted(_ address: Int64, size: Int) {
        
    }
    
    func executionFinished() {
        print("Execution finished")
        DispatchQueue.main.async {
            self.setValue(self.uni.read(.RAX).hexStr(min: 16), forKey: "rax")
            self.setValue(self.uni.read(.RBX).hexStr(min: 16), forKey: "rbx")
            self.setValue(self.uni.read(.RCX).hexStr(min: 16), forKey: "rcx")
            self.setValue(self.uni.read(.RDX).hexStr(min: 16), forKey: "rdx")
            self.updateDisplay()
        }
    }
}
