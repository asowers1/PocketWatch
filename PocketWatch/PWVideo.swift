//
//  PWVideo.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 11/29/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift
// A PWVideo represents an video assosiated with an PWObject
class PWVideo: Object {
  dynamic var item_id: Int = 0
  dynamic var video_id: Int = 0
  dynamic var src: String = ""
  dynamic var width: Int = 0
  dynamic var height: Int = 0
  dynamic var type: Int = 0
  dynamic var vid: String = ""
}
