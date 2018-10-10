//
//  CodeParser.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 10.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

enum ParserResult {
    case code(Substring), comment(Substring)
    
    func range(in code: String) -> NSRange {
        switch self {
        case .code(let substring), .comment(let substring):
            let location = code.distance(from: code.startIndex, to: substring.startIndex)
            let length = code.distance(from: substring.startIndex, to: substring.endIndex)
            return NSRange(location: location, length: length)
        }

    }
}

class CodeParser {
    enum State: Equatable, CustomDebugStringConvertible {
        case code(startIndex: String.Index), whitespace, comment(startIndex: String.Index)
        
        var debugDescription: String {
            switch self {
            case .comment:
                return "comment"
            case .code:
                return "code"
            case .whitespace:
                return "whitespace"
            }
        }
        
        func parserResult(code: String, endIndex: String.Index) -> ParserResult {
            switch self {
            case .comment(let startIndex):
                return .comment(code[startIndex..<endIndex])
            case .code(let startIndex):
                return .code(code[startIndex..<endIndex])
            case .whitespace:
                fatalError("parserResult() is not defined on CodeParser.State.whitespace")
            }
        }
    }

    static private let charSet = CharacterSet(charactersIn: "0123456789#ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz")
    static private let commentSet = CharacterSet(charactersIn: ";")
    
    
    static func parse(code: String) -> [ParserResult] {
        
        var state: State = .code(startIndex: code.startIndex)
        var result: [ParserResult] = []
        let charSet = CodeParser.charSet
        let commentSet = CodeParser.commentSet
        
        for currentIndex in code.indices {
            guard let scalar = code[currentIndex].unicodeScalars.first else {
                continue
            }
            var newState = state
            switch state {
            case .whitespace, .code:
                if commentSet.contains(scalar) {
                    newState = .comment(startIndex: currentIndex)
                } else if charSet.inverted.contains(scalar) {
                    newState = .whitespace
                } else if charSet.contains(scalar) {
                    newState = .code(startIndex: currentIndex)
                }
            case .comment:
                if scalar == "\n" {
                    newState = .whitespace
                }
            }
            
            if state != newState {
                switch state {
                case .code, .comment:
                    result.append(state.parserResult(code: code, endIndex: currentIndex))
                default:
                    break
                }
                state = newState
            }
        }
        
        switch state {
        case .code, .comment:
            result.append(state.parserResult(code: code, endIndex: code.endIndex))
        default:
            break
        }
        
        return result
    }
    
    
    
}


func ==(lhs: CodeParser.State, rhs: CodeParser.State) -> Bool {
    switch (lhs, rhs) {
    case (.code(_), .code(_)), (.comment(_), .comment(_)), (.whitespace, .whitespace):
        return true
    default:
        return false
    }
}
