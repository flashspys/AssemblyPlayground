//
//  String+Range.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

extension String {
    var fullRange: ClosedRange<String.Index> {
        return self.startIndex...self.endIndex
    }
}

extension Substring {
    var fullRange: ClosedRange<String.Index> {
        return self.startIndex...self.endIndex
    }
}
