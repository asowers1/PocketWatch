//
//  PWShuffleViewController.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/22/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards: UInt = 5

class PWShuffleViewController: UIViewController {
  
  @IBOutlet weak var kolodaView: KolodaView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.dataSource = self
    kolodaView.delegate = self
    
    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
  }
  
  //MARK: IBActions
  @IBAction func leftButtonTapped() {
    kolodaView?.swipe(SwipeResultDirection.Left)
  }
  
  @IBAction func rightButtonTapped() {
    kolodaView?.swipe(SwipeResultDirection.Right)
  }
  
  @IBAction func undoButtonTapped() {
    kolodaView?.revertAction()
  }
}

//MARK: KolodaViewDelegate
extension PWShuffleViewController: KolodaViewDelegate {
  
  func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
    //Example: loading more cards
    if index >= 3 {
      numberOfCards = 6
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
    return UIImageView(image: UIImage(named: "Card_like_\(index + 1)"))
  }
  
  func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
    return NSBundle.mainBundle().loadNibNamed("OverlayView",
      owner: self, options: nil)[0] as? OverlayView
  }
}

