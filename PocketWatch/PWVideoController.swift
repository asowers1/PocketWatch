//
//  PWVideoController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/6/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class PWVideoController: NSObject {

  static let sharedController = PWVideoController()
  
  // delete a certain video by its pocket item_id
  func deleteVideo(item_id: Int) {
    let realm = try! Realm()
    realm.write {
      realm.delete(realm.objects(PWVideo).filter("item_id = \(item_id)"))
    }
  }
}
