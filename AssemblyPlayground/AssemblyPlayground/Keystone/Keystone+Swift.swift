//
//  Keystone+swift.swift
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension Keystone {
    func assemble(string: String, emulationMode: EmulationMode) -> [UInt8]? {
        var size: Int = 0
        if let pointer = self.assemble(string, size: &size, emulationMode: emulationMode) {
            return Array(UnsafeBufferPointer(start: pointer, count: size))
        }
        return nil
    }
}
