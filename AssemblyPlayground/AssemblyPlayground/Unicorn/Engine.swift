//
//  Engine.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation
import PromiseKit

protocol EngineDelegate: class {
    func executionFinished()
    func compilerError(error: KeystoneError)
}

class Engine: NSObject {
    
    static var current: Engine? {
        return (NSApp.mainWindow?.windowController as? MainWindowController)?.engine
    }
    
    private let keystone = Keystone()
    var currentMetaData: [(Substring, ArraySlice<UInt8>)]?
    
    let unicorn: Unicorn
    let emulationMode: EmulationMode
    
    weak var delegate: EngineDelegate?
    
    let memory: UnsafeMutablePointer<Byte>
    let memorySize = 1024 * 1024 // = 1 MB
    
    init(emulationMode: EmulationMode) {
        self.emulationMode = emulationMode
        unicorn = Unicorn(emulationMode: emulationMode.rawValue)
        memory = UnsafeMutablePointer<Byte>.allocate(capacity: memorySize)
        super.init()
        unicorn.delegate = self
        unicorn.createMemory(withPointer: memory, size: memorySize)
    }
    
    func run(_ sourceCode: String) {
        keystone.assemble(string: sourceCode, emulationMode: emulationMode).done
        { (opcode: [UInt8], meta: [(Substring, ArraySlice<UInt8>)]) in
            self.currentMetaData = meta
            if self.unicorn.writeCode(code: opcode) {
                self.unicorn.run()
            }
        }.catch { (error) in
            if let keystoneError = error as? KeystoneError {
                self.delegate?.compilerError(error: keystoneError)
            }
        }
    }
    
}

extension Engine: UnicornDelegate {
    func memoryWrite(to address: Int64, value: Int64, size: Int) {
        
    }
    
    func instructionExecuted(_ address: Int64, size: Int) {
        /*
         only for testing! Dery dirty dont do dis
         if let displayWindowController = (NSApp.mainWindow!.windowController as! MainWindowController).displayWindowController {
            DispatchQueue.main.async {
                displayWindowController.display?.setNeedsDisplay(displayWindowController.display!.bounds)
            }
        }*/
    }
    
    func executionFinished() {
        delegate?.executionFinished()
        print("Execution finished!")
    }
}
