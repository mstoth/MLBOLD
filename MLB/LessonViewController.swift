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

extension NSManagedObject {
    
    func addObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.add(value)
    }
    
    func removeObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.remove(value)
    }
}

class LessonViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSDatePickerCellDelegate, NSTextFieldDelegate {
    
    
    var  student:Student?
    var  lessonTable:NSTableView? = nil
    
    @IBOutlet weak var headingLabel: NSTextField!
    @IBAction func stepperChanged(_ sender: Any ) {
        durationTextField.stringValue = stepper.stringValue + " Minutes"
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        lessonTable?.reloadData()
        self.view.window?.close()
    }
    @IBAction func createLesson(_ sender: Any) {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        if ((student?.lessons?.count)!>0) {
            for lsn in (student?.lessons)! {
                if ((lsn as! Lesson).date == datePicker.dateValue as NSDate) {
                    return
                }
            }
        }
        let lsn = NSEntityDescription.insertNewObject(forEntityName: "Lesson", into: context) as! Lesson
        lsn.date = datePicker.dateValue as NSDate
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: stepper.stringValue)
        lsn.length = Int32(number!.intValue)
        
        student?.addObject(value:lsn,forKey: "lessons")
        do {
            try context.save()
            let a = NSAlert()
            a.alertStyle = NSAlertStyle.informational
            a.messageText = "Saved lesson \(student?.lessons?.count)"
            a.runModal()
        } catch {
            let a = NSAlert()
            a.alertStyle = NSAlertStyle.warning
            a.messageText = "Unable to save lesson"
            a.runModal()
        }
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
        
        datePicker.dateValue =  Date()
    }
    
}
