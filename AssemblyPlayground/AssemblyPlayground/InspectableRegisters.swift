//
//  InspectableRegisters.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation


struct InspectableRegisters {
    
    enum X86: String, CaseIterable {
        case RAX, RBX, RCX, RDX, RSI, RDI, RIP
        
        func correspondingX86Register() -> X86Register {
            switch self {
            case .RAX:
                return .RAX
            case .RBX:
                return .RBX
            case .RCX:
                return .RCX
            case .RDX:
                return .RDX
            case .RSI:
                return .RSI
            case .RDI:
                return .RDI
            case .RIP:
                return .RIP
            }
        }
    }
    
}
