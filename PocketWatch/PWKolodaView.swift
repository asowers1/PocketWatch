//
//  PWKolodaView.swift
//  PocketWatch
//
//  Created by Andrew Sowers on 12/24/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Koloda
import QuartzCore

class PWKolodaView: KolodaView {

  @IBOutlet weak var cardImageView: UIImageView!
  @IBOutlet weak var cardTitle: UILabel!
  
  override func layoutSubviews() {
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = true;
  }
  
  func setImage(image:UIImage) {
    self.cardImageView.image = image
  }
  
  func setTitle(title:String) {
    self.cardTitle.text = title
  }
  

}
