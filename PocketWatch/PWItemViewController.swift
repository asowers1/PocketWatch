//
//  PWItemViewController.swift
//  PocketWatch==
//
//  Created by Andrew Sowers on 12/13/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class PWItemViewController: UINavigationController, PWPocketWrapperDelegate  {
  
  let pocketWrapper: PWPocketWrapper = PWPocketWrapper.sharedWrapper() as! PWPocketWrapper
  let objectController: PWObjectController = PWObjectController.sharedController
  
  override func viewDidLoad() {
    // get latest data
    
    self.pocketWrapper.delegate = self
    self.view.backgroundColor = UIColor.whiteColor()
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
