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
    var selectedStudent:Student? = nil;
    
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
    
    
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("In performSegue");
        if (identifier == "LessonPageControllerID") {
            
        }
    }
    
    @IBAction func addLesson(_ sender: Any) {
        let i:Int = studentTableView.selectedRow
        if (i>=0) {
            let ss = getStudents()
            
            selectedStudent = ss[i] as Student
            let lsns = getLessonsForStudent(selectedStudent!)
        }
    }
    
    func getLessonsForStudent(_ s:Student) -> [Lesson] {
        if (selectedStudent==nil) {
            return []
        }
        return selectedStudent?.lessons?.allObjects as! [Lesson]
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
        if (segue.identifier == "NewLessonSegueID") {
            guard let lessonPageViewController = segue.destinationController as? LessonPageController
                else {
                    return
            }
            let ss = getStudents()
            let i = studentTableView.selectedRow
            selectedStudent = ss[i] as Student

            print(selectedStudent as Any)
            lessonPageViewController.lessons = getLessonsForStudent(selectedStudent!) as [Lesson]
        }
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

