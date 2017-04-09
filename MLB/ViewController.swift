//
//  ViewController.swift
//  MLB
//
//  Created by Michael Toth on 3/15/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Cocoa
import Contacts

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var numStudentsLabel: NSTextField!
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView == studentTableView) {
            return numberOfStudents()
        }
        return 0
    }
    
    @IBOutlet weak var lessonTableView: NSTableView!
    @IBOutlet weak var studentTableView: NSTableView!
    
    func numberOfStudents() -> Int {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        return results.count
    }
    
    func numberOfLessons() -> Int {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lesson")
        let results = try! context.fetch(request) as! [Lesson]
        if (studentTableView.selectedRow < 0) {
            return 0
        }
        
        return 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        if (results.count == 0) { // there are no students
            let contact = CNMutableContact()
            let store = CNContactStore()
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (auth, error) in
                if (!auth) {
                    NSApplication.shared().terminate(self)
                }
            })
        }
        // Do any additional setup after loading the view.
        
        if (results.count != 1) {
            numStudentsLabel.stringValue = "You have \(results.count) students."
        } else {
            numStudentsLabel.stringValue = "You have \(results.count) student."
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        guard let addStudentController = segue.destinationController
            as? AddStudent else {
                guard let removeStudentController = segue.destinationController as? RemoveStudent else {
                    return
                }
                removeStudentController.mainView = self
                return
        }
        addStudentController.mainView = self
    }
    
    
    
    override func viewWillAppear() {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [NSManagedObject]
        if (results.count != 1) {
            numStudentsLabel.stringValue = "You have \(results.count) students."
        } else {
            numStudentsLabel.stringValue = "You have \(results.count) student."
        }
    }
}

