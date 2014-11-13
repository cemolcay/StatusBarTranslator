//
//  AppDelegate.swift
//  StatusBarTranslator
//
//  Created by Cem Olcay on 13/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var popover : NSPopover?
    
    let icon: IconView;
    
    override init() {
        let bar = NSStatusBar.systemStatusBar();
        let item = bar.statusItemWithLength(-1);
        
        self.icon = IconView(imageName: "icon", item: item);
        item.view = icon;
        
        super.init();
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?)
    {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(aNotification: NSNotification?)
    {
        // Insert code here to tear down your application
    }
    
    override func awakeFromNib()
    {
        //NSRectEdge is not enumerated yet; NSMinYEdge == 1
        //@see NSGeometry.h
        let edge = 1
        let icon = self.icon
        let rect = icon.frame
        
        icon.onMouseDown = {
            if (icon.isSelected)
            {
                self.popover!.showRelativeToRect(rect, ofView: icon, preferredEdge: edge);
                return
            }
            self.popover!.close()
        }
    }


}

