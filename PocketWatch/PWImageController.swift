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
  
  // get all objects
  var allObjects: Results<PWImage> {
    let realm = try! Realm()
    return realm.objects(PWImage)
  }
  
  // add a new object
  func addObject(item_id: Int, image_id: Int, src: String, width: Int, height: Int, credit: String) {
    let realm = try! Realm()
    let image: PWImage = PWImage()
    image.item_id = item_id
    image.image_id = image_id
    image.src = src
    image.width = width
    image.height = height
    image.credit = credit
    try! realm.write {
      realm.add(image)
    }
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
