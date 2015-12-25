//
//  PWShuffleViewController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/22/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Koloda
import RealmSwift

class PWShuffleViewController: UIViewController, PWPocketWrapperDelegate {
  
  let objectController: PWObjectController = PWObjectController.sharedController
  
  var objectData: Results<PWObject> {
    get {
      return objectController.allObjects
    }
  }
  
  var numberOfCards: UInt = 0
  
  @IBOutlet weak var kolodaView: KolodaView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.dataSource = self
    kolodaView.delegate = self
    
    numberOfCards = UInt(self.objectData.count)
    
    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
  }
  
  //MARK: IBActions
  @IBAction func leftButtonTapped() {
    kolodaView?.swipe(SwipeResultDirection.Left)
  }
  
  @IBAction func rightButtonTapped() {
    kolodaView?.swipe(SwipeResultDirection.Right)
  }
  
  func pocketDidGetData() {
    // did get new data
  }
  
  func pocketDidSaveData() {
    // did save new data - this is where we should reload data
  }
}

//MARK: KolodaViewDelegate
extension PWShuffleViewController: KolodaViewDelegate {
  
  func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
    //Example: loading more cards
    if index >= 3 {
      numberOfCards = UInt(self.objectData.count)
      kolodaView.reloadData()
    }
  }
  
  func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
    //Example: reloading
    kolodaView.resetCurrentCardNumber()
  }
  
  func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
  }
}

//MARK: KolodaViewDataSource
extension PWShuffleViewController: KolodaViewDataSource {
  
  func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
    return numberOfCards
  }
  
  func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
    let view = NSBundle.mainBundle().loadNibNamed("PWKolodaView", owner: self, options: nil)[0] as! PWKolodaView
    
    let object: PWObject = self.objectData[Int(index)] as PWObject
      
    view.setTitle(object.resolved_title)
    return view
  }
  
  func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
    return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
      owner: self, options: nil)[0] as? OverlayView
  }
}

