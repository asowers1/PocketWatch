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

    
    func createUser(user_id: Int, pocket_id: Int, first_name: String, last_name: String, token: String) {
        // destroy old user just in case
        self.destroyUser()
        let realm = try! Realm()
        let user: PWUser = PWUser()
        user.user_id = user_id
        user.pocket_id = pocket_id
        user.first_name = first_name
        user.last_name = last_name
        user.token = token
        realm.write {
            realm.add(user)
        }
    }
    
    // deletes all 'PWUser' objects from the realm
    func destroyUser() {
        let realm = try! Realm()
        realm.beginWrite()
        realm.write {
            realm.delete(realm.objects(PWUser))

        }
    }
}