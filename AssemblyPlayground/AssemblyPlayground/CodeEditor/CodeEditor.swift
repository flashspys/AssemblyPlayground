//
//  CodeEditor.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 10.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import AppKit

class CodeEditor: NSTextView {
    let dict: [Substring: NSColor] = ["inc": NSColor.red, "rax": NSColor.blue]

    fileprivate func buildRulerView() {
        NSScrollView.rulerViewClass = CodeEditorRuler.self
        self.enclosingScrollView?.hasVerticalRuler = true
        self.enclosingScrollView?.rulersVisible = true
        
        let rulerView = self.enclosingScrollView?.verticalRulerView as? CodeEditorRuler
        rulerView?.ruleThickness = 20
        rulerView?.clientView = self
        rulerView?.addMarker(NSRulerMarker(rulerView: rulerView!, markerLocation: 100, image: NSImage(named: "breakpoint")!, imageOrigin: NSPoint(x: 0, y: 0)))
        
        self.enclosingScrollView?.hasHorizontalScroller = true
        self.textContainer?.widthTracksTextView = false
        self.textContainer?.heightTracksTextView = false
        self.textContainer?.containerSize = NSSize(width: 1000000, height: 1000000)
        self.isHorizontallyResizable = true
    }
    
    override func awakeFromNib() {
        buildRulerView()
        self.delegate = self
    }
    
}

extension CodeEditor: NSTextViewDelegate {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: self.string.count)
    }
    
    
    func textDidChange(_ notification: Notification) {
        // Get the code and reset the textcolor
        let code = self.string
        self.setTextColor(nil, range: self.fullRange)
        
        // Characters we want to seperate
        let charSet = CharacterSet(charactersIn: "0123456789#ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz;")
        
        // Get the chunks seperated by the above set
        let chunks = code.split(maxSplits: Int.max, omittingEmptySubsequences: true) { (char) -> Bool in
            if let unicodeScalar = char.unicodeScalars.first {
                return charSet.inverted.contains(unicodeScalar)
            }
            return false
        }
        
        // Check highlighting for each substring
        for substring in chunks {
            if let color = dict[substring] {
                let location = code.distance(from: code.startIndex, to: substring.startIndex)
                let length = code.distance(from: substring.startIndex, to: substring.endIndex)
                
                self.setTextColor(color, range: NSRange(location: location, length: length))
            }
        }
    }
    
}
