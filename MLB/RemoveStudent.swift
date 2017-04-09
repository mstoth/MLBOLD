    //
//  RemoveStudent.swift
//  MLB
//
//  Created by Michael Toth on 4/5/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Cocoa

class RemoveStudent: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var results:[Student]? = []
    var rowSelected:Int = -1
    var mainView:ViewController? = nil
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var removeButton: NSButton!
    
    
    @IBAction func removeStudent(_ sender: Any) {
        if (rowSelected >= 0) {
            let delegate = NSApplication.shared().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            context.delete((results?[rowSelected])!)

            do {
                try context.save()
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
                results = try! context.fetch(request) as! [Student]
            } catch {
                return
            }
        }
        
        tableView.reloadData()
        mainView?.viewWillAppear()
        self.view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        results = try! context.fetch(request) as! [Student]
    }  
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results!.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let s = results?[row] else {
            return nil
        }
        if (tableColumn == tableView.tableColumns[0]) {
            if let cell = tableView.make(withIdentifier: "NameCell", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = "\(s.firstName!) \(s.lastName!)"
                if (s.image != nil) {
                    cell.imageView?.image = NSImage(data: s.image as! Data)
                }
                
                return cell
            }
        }
        if (tableColumn == tableView.tableColumns[1]) {
            if let cell = tableView.make(withIdentifier: "AddrCell", owner: nil) as? NSTableCellView {
                cell.textField?.lineBreakMode = NSLineBreakMode.byWordWrapping
                var ss:String = s.street! + "\n"
                ss = ss + s.city! + ", "
                ss = ss + s.state! + " " + s.zip!
                cell.textField?.stringValue = ss
                return cell
            }
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let tbl = notification.object as! NSTableView
        rowSelected = tbl.selectedRow
    }
    
    
}
