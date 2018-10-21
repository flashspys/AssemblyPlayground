//
//  Keystone+swift.swift
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation
import PromiseKit

extension Keystone {
    func assemble(string: String, emulationMode: EmulationMode) -> Promise<(opcode: [UInt8], meta: [(Substring, ArraySlice<UInt8>)])> {
        var size: Int = 0

        return Promise { (seal) in
            if let pointer = self.assemble(string, size: &size, emulationMode: emulationMode.rawValue),
                size > 0 {
                let metaData = self.metaData as Array<Array<Array<NSNumber>>>
                
                // Success, we have valid opcodes lets fill the metaData
                var meta = [(Substring, ArraySlice<UInt8>)]()
                let opcode = Array(UnsafeBufferPointer(start: pointer, count: size))
                for statement in metaData {
                    let assemblyMetaData = statement[0]
                    let opcodeMetaData = statement[1]
                    
                    let assemblyStartIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[0].intValue)
                    let assemblyEndIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[1].intValue)
                    
                    let substring = string[assemblyStartIndex..<assemblyEndIndex]
                    let opcodeSlice = opcode[opcodeMetaData[0].intValue..<opcodeMetaData[1].intValue]
                    
                    meta.append((substring, opcodeSlice))
                }
                
                return seal.fulfill((opcode: opcode, meta: meta))
            } else {
                let metaData = self.metaData as Array<Array<Array<NSNumber>>>
                
                // Error, invalid opcode size. Let's get together the metaData we have.
                var meta = [Substring]()
                for statement in metaData {
                    let assemblyMetaData = statement[0]
                    let assemblyStartIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[0].intValue)
                    let assemblyEndIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[1].intValue)
                    
                    let substring = string[assemblyStartIndex..<assemblyEndIndex]
                    
                    meta.append(substring)
                }
                
                let error: KeystoneError
                if let lastSubstring = meta.last {
                    var asmError: ASMError?
                    if let errorNumber = lastErrorNumber?.intValue {
                        asmError = ASMError(rawValue: errorNumber)
                    }
                    error = KeystoneError.compilerError(asmError ?? .unknown, lastSubstring)
                    
                } else {
                    error = KeystoneError.unknown
                }
                seal.reject(error)
            }
            
        }

    }
}
