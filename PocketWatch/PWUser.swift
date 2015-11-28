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
    dynamic var pocket_id = 0
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var token = ""
    
}
