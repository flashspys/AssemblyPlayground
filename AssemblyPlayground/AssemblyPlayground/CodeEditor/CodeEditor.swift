//
//  CodeEditor.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 10.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import AppKit

class CodeEditor: NSTextView {
    
    static let width = 20
    
    var colorSet: [Set<String>: NSColor] = [:]
    var numberColor: NSColor = .blue
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: self.string.count)
    }
    
    fileprivate func buildRulerView() {
        NSScrollView.rulerViewClass = CodeEditorRuler.self
        self.enclosingScrollView?.hasVerticalRuler = true
        self.enclosingScrollView?.rulersVisible = true
        
        let rulerView = self.enclosingScrollView?.verticalRulerView as? CodeEditorRuler
        rulerView?.ruleThickness = CodeEditorRuler.rulerWidth
        rulerView?.clientView = self
        //rulerView?.addMarker(NSRulerMarker(rulerView: rulerView!, markerLocation: 100, image: NSImage(named: "breakpoint")!, imageOrigin: NSPoint(x: 0, y: 0)))
        
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
    
    func highlight(range: NSRange, color: NSColor) {
        self.textStorage?.addAttribute(.backgroundColor, value: color, range: range)
    }
    
    func removeAllHighlights() {
        self.textStorage?.removeAttribute(.backgroundColor, range: fullRange)
    }
    
}

extension CodeEditor: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        // Get the code and reset the textcolor
        let code = self.string
        self.setTextColor(nil, range: self.fullRange)
        
        // Characters we want to seperate
        
        let results = CodeParser.parse(code: code)
        for result in results {
            var color: NSColor?
            switch result {
            case .code(let substring):
                for (set, highlightColor) in colorSet {
                    let string = String(substring)
                    if set.contains(string.uppercased()) {
                        color = highlightColor
                    } else {
                        if string.range(of: "^(?>(?>(?>0x|0X)[\\da-fA-F]+)|\\d+)$",
                                        options: .regularExpression,
                                        range: nil,
                                        locale: nil) != nil {
                            color = numberColor
                        }
                    }
                }
            case .comment:
                color = NSColor.gray
            }
            self.setTextColor(color, range: result.range(in: code))
        }
        
    }
    
}
