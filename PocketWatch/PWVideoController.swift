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
  
  // add a new object
  func addObject(item_id: Int, video_id: Int, src: String, width: Int, height: Int, type: Int, vid: String) {
    let realm = try! Realm()
    let video: PWVideo = PWVideo()
    video.item_id = item_id
    video.video_id = video_id
    video.src = src
    video.width = width
    video.height = height
    video.vid = vid
    try! realm.write {
      realm.add(video)
    }
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
