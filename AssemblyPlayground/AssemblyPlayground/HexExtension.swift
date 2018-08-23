//
//  HexExtension.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 22.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension String {
    var drop0xPrefix: String {
        return hasPrefix("0x") ? String(self.dropFirst(2)) : self
    }
    
    var hexaToDecimal: UInt64 {
        return UInt64(drop0xPrefix, radix: 16) ?? 0
    }
}

extension UInt64 {
    var toHexaString: String {
        return "0x"+String(self, radix: 16)
    }
    
    func hexStr(min: Int) -> String {
        var str = self.toHexaString.drop0xPrefix
        while str.count < min {
            str = "0" + str
        }
        return "0x" + str
    }
}
