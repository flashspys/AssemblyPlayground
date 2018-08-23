//
//  CodeEditorViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class CodeEditorViewController: NSViewController {

    @IBOutlet var sourceTextView: SourceTextView!
    
    var sourceCode: String {
        get {
            return sourceTextView.string
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceTextView.keywordColors = ["inc": NSColor.red]
        // Do view setup here.
    }
    
    
    
}
