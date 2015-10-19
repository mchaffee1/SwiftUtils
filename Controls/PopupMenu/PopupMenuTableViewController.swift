//
//  PopupMenuTableViewController.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/*
View controller for PopupMenu class.
*/
import UIKit

protocol PopupMenuTableViewControllerDelegate: class {
  func popupMenuVCDismissed(selection: String)
}

class PopupMenuTableViewController: UITableViewController {
  var delegate: PopupMenuTableViewControllerDelegate?
  
  var values = [String]()  // these are populated with the button texts in order
  var suppressDidDisappear = false  // Used to suppress a spurious viewDidDisappear call on selection-made
  
  private let bundleIdentifier = "com.chaf.SwiftUtils"
  private let cellIdentifier = "PopupMenuTableViewCell"
  
  convenience init() {
    self.init(nibName: "PopupMenuTableViewController", bundle: NSBundle(identifier: "com.chaf.SwiftUtils"))
    tableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle(identifier: bundleIdentifier)), forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return values.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let value = values[indexPath.row]
    let cell: PopupMenuTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? PopupMenuTableViewCell
    
    cell.value = value
    cell.viewController = self
    
    return cell
  }
  
  // Send an empty string back to the delegate to indicate cancel-with-no-selection
  override func viewDidDisappear(animated: Bool) {
    if !suppressDidDisappear {
      self.delegate?.popupMenuVCDismissed("")
    }
  }

  // Send back the selected value after the user touched it
  internal func cellButtonPressed(value: String) {
    // Stick our delegate in a holding tank while the dismissViewController operation takes place.
    // To avoid spurious empty callbacks.
    suppressDidDisappear = true
    dismissViewControllerAnimated(true) {
      self.delegate?.popupMenuVCDismissed(value)
    }
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
