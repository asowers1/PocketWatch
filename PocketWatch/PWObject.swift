//
//  PWObject.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 11/27/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift

class PWObject: Object {
    dynamic var id = 0
    dynamic var excerpt = ""
    dynamic var favorite = 0
    dynamic var given_title = ""
    dynamic var given_url = ""
    dynamic var has_image = 0;
    dynamic var has_video = 0
    dynamic var is_article = 0
    dynamic var is_index = 0
    dynamic var item_id = 0
    dynamic var resolved_id = 0
    dynamic var resolved_title = ""
    dynamic var resolved_url = ""
    dynamic var sort_id = 0
    dynamic var status = 0
    dynamic var time_added = 0
    dynamic var time_favorited = 0
    dynamic var time_read = 0
    dynamic var time_updated = 0
    dynamic var word_count = 0
}
