//
//  CodeEditorViewController.swift
//  AssemblyPlayground
//
//  Created by Felix Wehnert on 21.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

import Cocoa

class CodeEditorViewController: NSViewController {

    @IBOutlet var sourceTextView: CodeEditor!
    
    var assembly: String {
        return attributedSourceCode.string
    }
    
    @objc var attributedSourceCode: NSAttributedString = NSAttributedString(string: "") {
        didSet {
            (NSDocumentController.shared.currentDocument as? Document)?.data.assembly = self.assembly
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let assembly = (NSDocumentController.shared.documents.last as? Document)?.data.assembly {
            self.setValue(NSAttributedString(string: assembly), forKey: "attributedSourceCode")
        }
        //sourceTextView.keywordColors = ["inc": NSColor.red]
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        
    }
    
}
