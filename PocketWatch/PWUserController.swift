//
//  PWUserController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 11/27/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PWUserController: NSObject {
    
    static let sharedController = PWUserController()
    
    var user: PWUser {
      let realm = try! Realm()
      if let users: Results = realm.objects(PWUser) {
        return users.count > 0 ? users[0] : PWUser()
      } else {
        return PWUser()
      }
    }
    
    func createUser(user_id: Int, username: String, phone_number: String) {
        // destroy old user just in case
        self.destroyUser()
        let realm = try! Realm()
        let user: PWUser = PWUser()
        user.user_id = user_id
        user.username = username
        user.phone_number = phone_number
        try! realm.write {
            realm.add(user)
        }
    }
    
    // deletes all 'PWUser' objects from the realm
    func destroyUser() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(PWUser))

        }
    }
}
