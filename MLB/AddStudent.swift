//
//  AddStudent.swift
//  MLB
//
//  Created by Michael Toth on 3/20/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Foundation
import Cocoa
import Contacts

class AddStudent: NSViewController, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource {
    var objects: [Any] = []
    var contacts: [CNContact]? = []
    var firstName: String = ""
    var lastName: String = ""
    var rowSelected: Int = -1
    var mainView: NSViewController? = nil
    
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var workPhoneTextField: NSTextField!
    @IBOutlet weak var cellPhoneTextField: NSTextField!
    @IBOutlet weak var homePhoneTextField: NSTextField!
    @IBOutlet weak var zipTextField: NSTextField!
    @IBOutlet weak var stateTextField: NSTextField!
    @IBOutlet weak var streetTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var matchingLabel: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!
    @IBOutlet weak var firstNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func addStudentToDatabase(_ c:CNContact?) {
        
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let s = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
        
        if (rowSelected < 0) {
            return
        }
        let c = (contacts?[rowSelected])! as CNContact
        s.firstName = c.givenName
        s.lastName = c.familyName
        let addrs = c.postalAddresses
        let a1 = addrs[0].value as CNPostalAddress
        s.street = a1.street
        s.city = a1.city
        s.state = a1.state
        s.zip = a1.postalCode
        let ems = c.emailAddresses
        s.email = ems[0].value as String
        s.image = c.thumbnailImageData as NSData?
        let phs = c.phoneNumbers as [CNLabeledValue<CNPhoneNumber>]

        let p1 = phs[0].value as CNPhoneNumber
        s.phone = p1.stringValue
        do {
            try context.save()
            let a = NSAlert()
            a.alertStyle = NSAlertStyle.informational
            a.messageText = "Saved into Student Database"
            a.runModal()
        } catch {
            let a = NSAlert()
            a.alertStyle = NSAlertStyle.warning
            a.messageText = "Unable to save contact"
            a.runModal()
        }
        mainView?.viewWillAppear()
        self.view.window?.close()
    }
    
    
    @IBAction func addToContacts(_ sender: Any) {
        let c = CNMutableContact()
        
        // name
        c.familyName = lastNameTextField.stringValue
        c.givenName = firstNameTextField.stringValue
        
        // phone numbers
        let mobile = CNLabeledValue(label:CNLabelPhoneNumberMobile, value:CNPhoneNumber(stringValue:cellPhoneTextField                                                                                                                                                                                                                                                                                                                                                  .stringValue))
        let home = CNLabeledValue(label:CNLabelPhoneNumberMain, value:CNPhoneNumber(stringValue:homePhoneTextField.stringValue))
        let work = CNLabeledValue(label:CNLabelPhoneNumberMain, value:CNPhoneNumber(stringValue:workPhoneTextField.stringValue))
        let phoneNumbers = [home,mobile,work]
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: emailTextField.stringValue as NSString)
        let emails = [homeEmail]
        c.emailAddresses = emails
        c.phoneNumbers = phoneNumbers
        
        // address
        let pa = CNMutablePostalAddress()
        pa.street = streetTextField.stringValue
        pa.city = cityTextField.stringValue
        pa.postalCode = zipTextField.stringValue
        c.postalAddresses = [CNLabeledValue(label:CNLabelHome, value: pa)]
        
        // image
        c.imageData = profileImage.image?.tiffRepresentation
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(c, toContainerWithIdentifier: nil)
        let store = CNContactStore()
        do {
            try store.execute(saveRequest)
            tableView.reloadData()
        } catch {
            print("Error Saving Contact.")
        }
    }
    
    
    @IBAction func clear(_ sender: Any) {
        for v:Any in self.view.subviews {
            let m = Mirror(reflecting: v)
            if (m.subjectType == NSTextField.self) {
                (v as! NSTextField).stringValue = ""
            }
        }
    }
    
    @IBAction func addContact(_ sender: Any) {
        let delegate = NSApplication.shared().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let results = try! context.fetch(request) as! [Student]
        if (results.count == 0) {
            if (rowSelected>=0) {
                let s = contacts?[rowSelected]
                addStudentToDatabase(s)
            }
            tableView.reloadData()
            return
        }
        
        for student:Student in results {
            let fn = student.firstName
            let ln = student.lastName
            if ((fn == firstNameTextField.stringValue) &&
                (ln == lastNameTextField.stringValue)) {
                let a = NSAlert()
                a.alertStyle = NSAlertStyle.warning
                a.addButton(withTitle: "Ok")
                a.addButton(withTitle: "Cancel")
                a.messageText = "There is already a student with that name. Are you sure? "
                let r = a.runModal()
                if (r==NSAlertFirstButtonReturn) {
                    if (rowSelected>=0) {
                        let s = contacts?[rowSelected]
                        addStudentToDatabase(s)
                    }
                }
                if (r==NSAlertSecondButtonReturn) {
                    return
                }
            } else {
                addStudentToDatabase(contacts?[rowSelected])
            }
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let tbl = notification.object as! NSTableView
        rowSelected = tbl.selectedRow
        if (rowSelected < 0) {
            return
        }
        if (contacts?[rowSelected]==nil) {
            return
        }
        let contact = contacts?[rowSelected]
        let fn = contact?.givenName
        let ln = contact?.familyName
        if (firstNameTextField.stringValue != fn) {
            firstNameTextField.stringValue = fn!
        }
        if (lastNameTextField.stringValue != ln) {
            lastNameTextField.stringValue = ln!
        }
        
        let em = (contact?.emailAddresses[0])! as CNLabeledValue<NSString>
        let email = em.value as NSString
        emailTextField.stringValue = String(describing: email)
        
        let pa = (contact?.postalAddresses[0])! as CNLabeledValue<CNPostalAddress>
        let addr = pa.value as CNPostalAddress
        streetTextField.stringValue = addr.street
        cityTextField.stringValue = addr.city
        stateTextField.stringValue = addr.state
        zipTextField.stringValue = addr.postalCode
        
        if ((contact?.phoneNumbers.count)! > 0) {
            for pn:CNLabeledValue<CNPhoneNumber> in (contact?.phoneNumbers)! {
                let pnum = pn.value as CNPhoneNumber
                if (pn.label == CNLabelHome) {
                    homePhoneTextField.stringValue = pnum.stringValue
                }
                if (pn.label == CNLabelPhoneNumberMobile) {
                    cellPhoneTextField.stringValue = pnum.stringValue
                }
                if (pn.label == CNLabelWork) {
                    workPhoneTextField.stringValue = pnum.stringValue
                }
            }
        }
        
        if ((contact?.thumbnailImageData) != nil) {
            profileImage.image = NSImage(data: (contact?.thumbnailImageData)!)!
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return contacts!.count
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        firstName = firstNameTextField.stringValue;
        lastName = lastNameTextField.stringValue
        let store = CNContactStore()
        
        store.requestAccess(for: CNEntityType.contacts, completionHandler: { (auth, error) in
            if (!auth) {
                NSApplication.shared().terminate(self)
            }
        })
        
        let predicate = CNContact.predicateForContacts(matchingName: firstName + " " + lastName)
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactPostalAddressesKey,CNContactEmailAddressesKey, CNContactThumbnailImageDataKey] as [Any]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        matchingLabel.stringValue = "\(contacts!.count) contacts matching"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 44.0;
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let contact = contacts?[row] else {
            return nil
        }
        if (tableColumn == tableView.tableColumns[0]) {
            if let cell = tableView.make(withIdentifier: "NameCell", owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = "\(firstName) \(lastName)"
                if ((contact.thumbnailImageData) != nil) {
                    cell.imageView?.image = NSImage(data: (contact.thumbnailImageData)!)!
                }
                
                return cell
            }
        }
        if (tableColumn == tableView.tableColumns[1]) {
            if let cell = tableView.make(withIdentifier: "AddressCell", owner: nil) as? NSTableCellView {
                if (contact.postalAddresses.count>0)  {
                    let adr = contact.postalAddresses[0] as CNLabeledValue<CNPostalAddress>
                    
                    let addr = adr.value as CNPostalAddress
                                        
                    cell.textField?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    
                    cell.textField?.stringValue = addr.street + "\n" + addr.city + ", " +  addr.state + " " + addr.postalCode
                    
                    return cell
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
        return nil
    }
    
}
