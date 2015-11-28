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

//    class var sharedController: PWUserController {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: PWUserController? = nil
//        }
//        dispatch_once(&Static.onceToken) {
//            Static.instance = PWUserController()
//        }
//        return Static.instance!
//    }
    
    static let sharedController = PWUserController()
    
    var user: PWUser {
        let realm = try! Realm()
        return realm.objects(PWUser)[0]
    }
    
    func createUser(user_id: Int, username: String, phone_number: String) {
        // destroy old user just in case
        self.destroyUser()
        let realm = try! Realm()
        let user: PWUser = PWUser()
        user.user_id = user_id
        user.username = username
        user.phone_number = phone_number
        realm.write {
            realm.add(user)
        }
    }
    
    // deletes all 'PWUser' objects from the realm
    func destroyUser() {
        let realm = try! Realm()
        realm.write {
            realm.delete(realm.objects(PWUser))

        }
    }
}
