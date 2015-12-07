//
//  PWImageController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/6/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class PWImageController: NSObject {

  // delete a certain image by its pocket item_id
  func deleteImage(item_id: Int) {
    let realm = try! Realm()
    realm.write {
      realm.delete(realm.objects(PWImage).filter("item_id = \(item_id)"))
    }
  }
}
