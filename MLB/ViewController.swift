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
    @IBOutlet weak var lessonTableView: NSTableView!
    @IBOutlet weak var studentTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        studentTableView.delegate = self;
        studentTableView.dataSource = self;
        if (results.count == 0) { // there are no students
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
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView == studentTableView) {
            return numberOfStudents()
        } else {
            return numberOfLessons()
        }
    }
    
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
        let request4Students = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results4Students = try! context.fetch(request4Students) as! [Student]
        let student = results4Students[studentTableView.selectedRow] as Student
        return numberOfLessonsForStudent(stdnt: student)
    }
    
    func numberOfLessonsForStudent(stdnt:Student) ->Int {
        return (stdnt.lessons?.count)!
    }

    func getStudents() -> [Student] {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        return results
    }
    
    @IBAction func addLesson(_ sender: Any) {
        let s = getStudents()[studentTableView.selectedRow] as Student
        let lsns = getLessonsForStudent(s)
        
    }
    
    func getLessonsForStudent(_ s:Student) -> NSSet {
        return NSSet(array: [])
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if (tableView == studentTableView) {
            let s = getStudents()
            if let cell = tableView.make(withIdentifier: "MainStudentTableCellID", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = s[row].firstName! + " " + s[row].lastName!
                return cell
            }
        }
        if (tableView == lessonTableView) {
            if let cell = tableView.make(withIdentifier: "MainLessonTableCellID", owner: nil) as? NSTableCellView {
                let s = getStudents() as [Student]
                let n = studentTableView.selectedRow
                if (s.count == 0) {
                    return nil
                }
                let ss = s[n] // get the selected student
                var lsns = ss.lessons?.allObjects as! [Lesson]
                lsns.sort {($0.date as! Date) < ($1.date as! Date)}
                let ds = lsns[row].date as! Date
                let df = DateFormatter()
                cell.textField?.stringValue = df.string(from: ds)
                return cell
                }
            }
        return nil
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
        studentTableView.delegate = self;
        lessonTableView.delegate = self;
        studentTableView.dataSource  = self;
        lessonTableView.dataSource = self;
        studentTableView.reloadData();
        let results = try! context.fetch(request) as! [NSManagedObject]
        if (results.count != 1) {
            numStudentsLabel.stringValue = "You have \(results.count) students."
        } else {
            numStudentsLabel.stringValue = "You have \(results.count) student."
        }
    }
    
    
}

