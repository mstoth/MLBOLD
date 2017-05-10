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

class LessonViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSDatePickerCellDelegate, NSTextFieldDelegate {
    
    
    var  student:Student?
    
    @IBOutlet weak var headingLabel: NSTextField!
    @IBAction func stepperChanged(_ sender: Any ) {
        durationTextField.stringValue = stepper.stringValue + " Minutes"
    }
    
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var durationTextField: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        var lessonLength = defaults.integer(forKey: "defaultLessonLength")
        durationTextField.stringValue = stepper.stringValue + " Minutes"
        if (student == nil) {
            return
        }
        headingLabel.stringValue = "Lesson for " + (student?.firstName)! + " " + (student?.lastName)!
        
        datePicker.dateValue = Date()
    }
    
}
