//
//  LessonViewController.swift
//  MLB
//
//  Created by Michael Toth on 4/20/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Foundation
import Cocoa
import Contacts

class LessonViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSDatePickerCellDelegate {
    
    @IBOutlet weak var datePicker: NSDatePicker!
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        var lessonLength = defaults.integer(forKey: "defaultLessonLength")
        
    }
    
}
