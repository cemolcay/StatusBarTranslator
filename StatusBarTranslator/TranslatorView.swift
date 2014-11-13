//
//  TranslatorView.swift
//  StatusBarTranslator
//
//  Created by Cem Olcay on 13/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

enum TranslatorMode : Int {
    case enFr = 0
    case frEn = 1
}

class TranslatorView: NSView, NSTextFieldDelegate {

    // MARK: Properties
    
    let apiKey : String = "trnsl.1.1.20141113T085727Z.b79e2fcf3cd392b9.7104ece64c3b3800159fee7bd480721323d696df"
    
    var mode : TranslatorMode
    
    @IBOutlet var textField: NSTextField!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet var resultLabel: NSTextField!
    
    
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        mode = .enFr
        super.init(coder: coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    
    override func awakeFromNib() {
        progressIndicator.hidden = true
        progressIndicator.stopAnimation(self)
        resultLabel.stringValue = ""
        
        textField.target = self
        textField.action = "translate"
        
        mode = .frEn
    }
    
    
    
    // MARK: Translator
    
    @IBAction func modeChanged(sender: NSSegmentedControl) {
        mode = TranslatorMode (rawValue: sender.selectedSegment)!
    }
    
    func translate () {
        
        progressIndicator.hidden = false
        progressIndicator.startAnimation(self)
        resultLabel.stringValue = ""
        
        request(.GET, translateUrl(), parameters: nil, encoding: .JSON).responseSwiftyJSON { (request, response, json, error) -> Void in
            if let err = error {
                self.progressIndicator.hidden = true
                self.progressIndicator.stopAnimation(self)
            } else {
                self.progressIndicator.hidden = true
                self.progressIndicator.stopAnimation(self)
                
                var translated = ""
                let result = json["text"].arrayObject as [String]
                for i in 0...result.count-1 {
                    translated += result[i] + "\n"
                }
                
                self.resultLabel.stringValue = translated
            }
        }
    }
    
    func translateUrl () -> String {
        var lang : String = ""
        switch mode {
        case .enFr:
            lang = "en-fr"
        case .frEn:
            lang = "fr-en"
        default:
            lang = "en-fr"
        }
        
        let text = textField.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "+", options:NSStringCompareOptions.LiteralSearch, range: nil)
        let url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(apiKey)&lang=\(lang)&text=\(text)"
        return url
    }
}
