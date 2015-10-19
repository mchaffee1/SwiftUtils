//
//  PopupMenuTableViewCell.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit

class PopupMenuTableViewCell: UITableViewCell {

  @IBOutlet weak var button: UIButton!

  weak var viewController: PopupMenuTableViewController!
  
  var value = "" {
    didSet {
      button.setTitle(value, forState: .Normal)
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBAction func button_touchUpInside(sender: AnyObject) {
    viewController.cellButtonPressed(value)
  }
  
  
}
