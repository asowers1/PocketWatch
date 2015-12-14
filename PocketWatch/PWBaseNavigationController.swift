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

  override func viewDidLoad() {
    // get latest data
    self.pocketWrapper.getPocketData()
  }

  

}
