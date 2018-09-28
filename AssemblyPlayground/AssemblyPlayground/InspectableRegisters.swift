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
        case RAX, RBX, RCX, RDX, RSI, RDI, RIP, RSP, RBP,
        R8,
        R9,
        R10,
        R11,
        R12,
        R13,
        R14,
        R15
        
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
            case .RSP:
                return .RSP
            case .RBP:
                return .RBP
            case .R8:
                return .R8
            case .R9:
                return .R9
            case .R10:
                return .R10
            case .R11:
                return .R11
            case .R12:
                return .R12
            case .R13:
                return .R13
            case .R14:
                return .R14
            case .R15:
                return .R15
            }
        }
    }
    
    enum ARM64: String, CaseIterable {
        case R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15
    }
    
}
