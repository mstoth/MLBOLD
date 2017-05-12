//
//  extensions.swift
//  MLB
//
//  Created by Michael Toth on 5/12/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Cocoa

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
