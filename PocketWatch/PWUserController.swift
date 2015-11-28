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

    
    func createUser(user_id: Int, pokcet_id: Int, first_name: String, last_name: String, token: String) {
        // destroy old user just in case
        self.destroyUser()
        
    }
    
    // deletes all 'PWUser' objects from the realm
    func destroyUser() {
        let realm = try! Realm()
        realm.write {
            realm.delete(realm.objects(PWUser))

        }
    }
}
