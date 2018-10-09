//
//  EmulationMode.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 09.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

enum EmulationMode: Int32 {
    
    case x86, arm64 //, arm32, arm32thumb
    
    func inspectableRegisters() -> [InspectableRegister] {
        return self.registerType().inspectable()
    }
    
    func registerType() -> InspectableRegister.Type {
        switch self {
        case .x86:
            return Registers.X86.self
        case .arm64:
            return Registers.ARM64.self
        }
    }
}
