//
//  Keystone+swift.swift
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension Keystone {
    func assemble(string: String, emulationMode: EmulationMode) -> (opcode: [UInt8], meta: [(Substring, ArraySlice<UInt8>)])? {
        var size: Int = 0
        if let pointer = self.assemble(string, size: &size, emulationMode: emulationMode.rawValue),
            size > 0 {
            var meta = [(Substring, ArraySlice<UInt8>)]()
            let opcode = Array(UnsafeBufferPointer(start: pointer, count: size))
            let metaData = self.metaData as Array<Array<Array<NSNumber>>>
            for statement in metaData {
                let assemblyMetaData = statement[0]
                let opcodeMetaData = statement[1]
                
                let assemblyStartIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[0].intValue)
                let assemblyEndIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[1].intValue)
                
                let substring = string[assemblyStartIndex..<assemblyEndIndex]
                let opcodeSlice = opcode[opcodeMetaData[0].intValue..<opcodeMetaData[1].intValue]
                
                meta.append((substring, opcodeSlice))
            }
            print(meta)
            
            return (opcode, meta)
        } else {
            var meta = [Substring]()
            let metaData = self.metaData as Array<Array<Array<NSNumber>>>
            for statement in metaData {
                let assemblyMetaData = statement[0]
                let assemblyStartIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[0].intValue)
                let assemblyEndIndex = string.index(string.startIndex, offsetBy: assemblyMetaData[1].intValue)
                
                let substring = string[assemblyStartIndex..<assemblyEndIndex]
                
                meta.append(substring)
            }
            print("Error in \(meta.last) ")
            
        }
        return nil
    }
}
