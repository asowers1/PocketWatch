//
//  PWObjectController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 11/28/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PWObjectController: NSObject {
  
  static let sharedController = PWObjectController()
  
  // get all objects
  var allObjects: Results<PWObject> {
    let realm = try! Realm()
    return realm.objects(PWObject)
  }
  
  // add a new object to RLM
  func addObject(object: PWObject) {
    let realm = try! Realm()
    try! realm.write {
      realm.add(object)
    }
  }
  
  // get a new object
  internal func getNewObject() -> PWObject {
    return PWObject()
  }
  
  // deletes all <PWObject> objects from the realm
  func deleteObjects() {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWObject))
      
    }
  }
  
  // delete a certain object by its pocket id
  func deleteObject(item_id: Int) {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWObject).filter("item_id = \(item_id)"))
    }
  }
}
