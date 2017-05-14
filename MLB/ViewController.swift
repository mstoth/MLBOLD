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
    
    var students:[Student] = []
    
    @IBOutlet weak var numStudentsLabel: NSTextField!
    @IBOutlet weak var lessonTableView: NSTableView!
    @IBOutlet weak var studentTableView: NSTableView!
    
    var selectedStudent:Student? = nil;
    var selectedLesson:Lesson? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        studentTableView.delegate = self;
        studentTableView.dataSource = self;
        lessonTableView.delegate = self;
        lessonTableView.dataSource = self;
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
        students = getStudents()
    }
    
    @IBAction func removeLesson(_ sender: Any) {
        if (selectedLesson != nil) {
            let delegate = NSApplication.shared().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            context.delete(selectedLesson!)
            try! context.save()
            lessonTableView.reloadData()
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        if (tableView == studentTableView) {
            return numberOfStudents()
        } else {
            let n = numberOfLessons()
            print("\(n) lessons")
            return numberOfLessons()
        }
    }
    
    func numberOfStudents() -> Int {
        return students.count
    }
    
    func numberOfLessons() -> Int {
        if (studentTableView.selectedRow<0) {
            return 0
        }
        if (students.count <= 0) {
            return 0
        }
        return students[studentTableView.selectedRow].lessons!.count
        
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
    
    
    func tableView(tableView:NSTableView!, numberOfRowsInSection section: Int) -> Int {
        if (tableView == studentTableView) {
            return numberOfStudents()
        }
        if (tableView == lessonTableView) {
            print("returning \(numberOfLessons()) for number of lessons.")
            return numberOfLessons()
        }
        return 0
    }
    
    func getLessonsForStudent(_ s:Student) -> [Lesson] {
        if (selectedStudent==nil) {
            return []
        }
        return selectedStudent?.lessons?.allObjects as! [Lesson]
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if (studentTableView.selectedRow < 0) {
            lessonTableView.reloadData()
            return
        }
        selectedStudent = students[studentTableView.selectedRow]
        if (lessonTableView == notification.object as? NSTableView) {
            let row = lessonTableView.selectedRow
            if (row < 0) {
                return
            }
            var lsns = selectedStudent?.lessons?.allObjects as! [Lesson]
            lsns.sort {($0.date as! Date) < ($1.date as! Date)}
            selectedLesson = lsns[row]
            print(selectedLesson)
        } else {
            lessonTableView.reloadData()
        }
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
                var lsns = selectedStudent?.lessons?.allObjects as! [Lesson]
                lsns.sort {($0.date as! Date) < ($1.date as! Date)}
                let ds = lsns[row].date as! Date
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yyyy hh:mm"
                print(df.string(from:ds))
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
            if (i<0) {
                return
            }
            selectedStudent = ss[i] as Student

            lessonPageViewController.lessons = getLessonsForStudent(selectedStudent!) as [Lesson]
            lessonPageViewController.student = selectedStudent
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

