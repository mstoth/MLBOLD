//
//  LessonPageController.swift
//  MLB
//
//  Created by Michael Toth on 4/16/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Cocoa

class LessonPageController: NSPageController, NSPageControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.delegate = self;
        self.arrangedObjects = orderedViewControllers
        self.selectedIndex = 0
    }
    
    var orderedViewControllers: [NSViewController] = {
        return [
                NSStoryboard(name: "Main", bundle:nil).instantiateController(withIdentifier: "LessonViewID") as! LessonViewController,
                ]
    }()
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
    return self.storyboard?.instantiateController(withIdentifier: identifier) as! LessonViewController
    }
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> String {
        return "LessonViewID"
    }
    
}
