//
//  CodeEditorRuler.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 10.10.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Foundation

class CodeEditorRuler: NSRulerView {
    
    var selectedLine: ((Int) -> Void)?
    
    var lineHeight: CGFloat {
        guard let codeEditor = (clientView as? CodeEditor) else { return 0 }
        return codeEditor.layoutManager?.defaultLineHeight(for: codeEditor.font!) ?? 0
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let codeEditor = clientView as? CodeEditor else { return }
        
        // Fill the background
        NSColor(calibratedWhite: 0.8, alpha: 1).setFill()
        dirtyRect.fill()
        
        // Draw the breakpoints
        drawMarkers(in: dirtyRect)
        
        // Calculate all needed vars
        let start = Int((codeEditor.visibleRect.origin.y + dirtyRect.origin.y) / lineHeight + 1)
        var offset = fmod(codeEditor.visibleRect.origin.y + dirtyRect.origin.y, lineHeight) - 0.5 // minus magic number
        if self.clientView!.visibleRect.origin.y == 0 {
            // -2 because the heights differ in the normal case exactly 2 pixels (probably because of the border)
            offset -= codeEditor.enclosingScrollView!.bounds.height - codeEditor.visibleRect.height - 2
        }
        let numberOfLinesInRect = Int((dirtyRect.size.height / lineHeight) + 1)

        // Draw the line numbers
        for i in 0...numberOfLinesInRect {
            let point = CGPoint(x: 0, y: ((dirtyRect.origin.y / lineHeight) + CGFloat(i)) * lineHeight - offset)
            let string: NSString = "\(start+i)" as NSString
            string.draw(at: point, withAttributes: nil)
        }
    }
    
    /// handle a click on the CodeEditorRuler.
    override func mouseDown(with event: NSEvent) {
        guard let codeEditor = clientView as? CodeEditor else { return }
        let google = self.convert(event.locationInWindow, from: nil).y + codeEditor.visibleRect.origin.y
        let lineNumber = Int((google/lineHeight)+1)
        selectedLine?(lineNumber)
    }
}
