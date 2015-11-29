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
    
    // add a new object
    func addObject(user_id: Int, username: String, phone_number: String) {
        let realm = try! Realm()
        let user: PWUser = PWUser()
        user.user_id = user_id
        user.username = username
        user.phone_number = phone_number
        realm.write {
            realm.add(user)
        }
    }
    
    // deletes all <PWObject> objects from the realm
    func deleteObjects() {
        let realm = try! Realm()
        realm.write {
            realm.delete(realm.objects(PWObject))
            
        }
    }
    
    // delete a certain object by its pocket id
    func deleteObject(pocket_id: Int) {
        let realm = try! Realm()
        realm.write {
            realm.delete(realm.objects(PWObject).filter("pocket_id = \(pocket_id)"))
        }
    }
}
