//
//  Registers.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 09.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

struct Registers {
}

protocol InspectableRegister {
    init?(rawValue: Int32)
    static func inspectable() -> [InspectableRegister]
    func value(with engine: Engine) -> UInt64
    var rawValue: Int32 { get }
    var description: String { get }
}
