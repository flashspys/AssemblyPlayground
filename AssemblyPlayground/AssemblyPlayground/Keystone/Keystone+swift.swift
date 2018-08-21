//
//  Keystone+swift.swift
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension Keystone {
    func assemble(string: String) -> [UInt8] {
        var size: Int = 0
        let pointer = self.assemble(string, size: &size)
        return Array(UnsafeBufferPointer(start: pointer, count: size))
    }
}
