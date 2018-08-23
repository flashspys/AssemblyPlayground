//
//  Engine.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

protocol EngineDelegate {
    func executionFinished()
}

class Engine: NSObject {
    
    private var keystone = Keystone()
    var unicorn = Unicorn()
    
    var delegate: EngineDelegate?
    
    var memory: UnsafeMutablePointer<Byte>
    
    override init() {
        memory = UnsafeMutablePointer<Byte>.allocate(capacity: 1024*1024)
        super.init()
        unicorn.delegate = self
        unicorn.createMemory(withPointer: memory, size: 1024*1024)
    }
    
    func prepareCode(_ sourceCode: String) -> Bool {
        let opcode = keystone.assemble(string: sourceCode)
        return unicorn.writeCode(code: opcode)
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
