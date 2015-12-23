//
//  PWBaseNavigationController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/13/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class PWBaseNavigationController: UINavigationController, PWPocketWrapperDelegate {

  let pocketWrapper: PWPocketWrapper = PWPocketWrapper.sharedWrapper() as! PWPocketWrapper
  let objectController: PWObjectController = PWObjectController.sharedController

  override func viewDidLoad() {
    // get latest data
    let allObjects = objectController.allObjects
    if allObjects.count > 0 {
      for object in allObjects {
        NSLog("object: %@", object.resolved_url)
      }
    } else {
      self.pocketWrapper.getPocketData()
    }
    self.pocketWrapper.delegate = self
  }
  
  func pocketDidSaveData() {
    NSLog("did save data")
  }

  func pocketDidGetData() {
    NSLog("did get data")
  }
  

}
