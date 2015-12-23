//
//  PWImageController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/6/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PWImageController: NSObject {

  static let sharedController = PWImageController()
  
  // get all images
  var allObjects: Results<PWImage> {
    let realm = try! Realm()
    return realm.objects(PWImage)
  }
  
  // add a new image to RLM
  func addObject(image: PWImage) {
    let realm = try! Realm()
    try! realm.write {
      realm.add(image)
    }
  }
  
  // get a new image
  func getNewImage() -> PWImage {
    return PWImage()
  }
  
  // deletes all <PWImage> objects from the realm
  func deleteObjects() {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWImage))
      
    }
  }
  
  // delete a certain image by its pocket item_id
  func deleteImage(item_id: Int) {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(PWImage).filter("item_id = \(item_id)"))
    }
  }
}
