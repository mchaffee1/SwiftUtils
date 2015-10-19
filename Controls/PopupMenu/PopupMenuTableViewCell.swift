//
//  PopupMenuTableViewCell.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/*
A cell containing a button to be used in a PopupMenu.
The only kinda-special thing is, the cell keeps track of its view controller to pass back selection actions.
*/
import UIKit

class PopupMenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var button: UIButton!
  weak var viewController: PopupMenuTableViewController!
  
  var value = "" {
    didSet {
      button.setTitle(value, forState: .Normal)
    }
  }

  @IBAction func button_touchUpInside(sender: AnyObject) {
    viewController.cellButtonPressed(value)
  }
  
  
}
