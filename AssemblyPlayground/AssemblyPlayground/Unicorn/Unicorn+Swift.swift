//
//  Unicorn+Swift.swift
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension Unicorn {
    func writeCode(code: [UInt8]) -> Bool {
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(mutating: code)
        return self.writeCode(pointer, length: code.count) == -1 ? false : true
    }
    
    func readMemory(addr: UInt64, size: Int) -> [UInt8] {
        let pointer = self.readMemory(addr, size: size)
        return Array(UnsafeBufferPointer(start: pointer, count: size))
    }
    
    func writeMemory(address: UInt64, data: [UInt8]) {
        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(mutating: data)
        self.writeMemory(address, data: pointer, size: data.count)
    }
    
    func readRegister(_ inspectableRegister: InspectableRegisters.X86) -> UInt64 {
        return self.read(inspectableRegister.correspondingX86Register())
    }
}
