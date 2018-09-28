//
//  Engine.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

protocol EngineDelegate: class {
    func executionFinished()
}

class Engine: NSObject {
    
    static var current: Engine? {
        return (NSApp.mainWindow?.windowController as? MainWindowController)?.engine
    }
    
    private var keystone = Keystone()
    var unicorn: Unicorn
    var emulationMode: EmulationMode
    
    weak var delegate: EngineDelegate?
    
    var memory: UnsafeMutablePointer<Byte>
    let memorySize = 1024 * 1024
    
    init(emulationMode: EmulationMode) {
        self.emulationMode = emulationMode
        unicorn = Unicorn(emulationMode: emulationMode)
        memory = UnsafeMutablePointer<Byte>.allocate(capacity: memorySize)
        super.init()
        unicorn.delegate = self
        unicorn.createMemory(withPointer: memory, size: memorySize)
    }
    
    func prepareCode(_ sourceCode: String) -> Bool {
        if let opcode = keystone.assemble(string: sourceCode, emulationMode: emulationMode) {
            return unicorn.writeCode(code: opcode)
        } else {
            return false
        }
    }
    
    func run() {
        unicorn.run()
    }
    
    func reset() {
    }
    
}

extension Engine: UnicornDelegate {
    func memoryWrite(to address: Int64, value: Int64, size: Int) {
        
    }
    
    func instructionExecuted(_ address: Int64, size: Int) {
        
    }
    
    func executionFinished() {
        delegate?.executionFinished()
        print("Execution finished!")
    }
}
