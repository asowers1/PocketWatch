//
//  PWUser.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 11/27/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift

class PWUser: Object {
    
    dynamic var user_id = 0
    dynamic var username = ""
    dynamic var phone_number = ""
}
