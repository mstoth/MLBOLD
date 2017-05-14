//
//  LessonPageController.swift
//  MLB
//
//  Created by Michael Toth on 4/16/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Cocoa

class LessonPageController: NSPageController, NSPageControllerDelegate {

    var lessons:[Lesson] = [];
    var student:Student? = nil;
    var lessonTable:NSTableView? = nil;
    
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
    
    func viewControllerForLesson(_ lsn:Lesson) -> LessonViewController {
        let c = self.storyboard?.instantiateController(withIdentifier: "LessonViewControllerID") as! LessonViewController
        return c
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
        
        let lvc = self.storyboard?.instantiateController(withIdentifier: identifier) as! LessonViewController
        lvc.student = student
        lvc.lessonTable = lessonTable
        return lvc
    }
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> String {
        return "LessonViewID"
    }
    
}
