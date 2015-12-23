//
//  PWVideoController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/6/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PWVideoController: NSObject {

  static let sharedController = PWVideoController()
  
  // get all objects
  var allObjects: Results<PWVideo> {
    let realm = try! Realm()
    return realm.objects(PWVideo)
  }
  
  // add a new video to RLM
  func addObject(video: PWVideo) {
    let realm = try! Realm()
    try! realm.write {
      realm.add(video)
    }
  }
  
  // get a new video
  func getNewVideo() -> PWVideo {
    return PWVideo()
  }
  
  // deletes all <PWImage> objects from the realm
  func deleteObjects() {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWVideo))
      
    }
  }
  
  // delete a certain video by its pocket item_id
  func deleteVideo(item_id: Int) {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWVideo).filter("item_id = \(item_id)"))
    }
  }
}
