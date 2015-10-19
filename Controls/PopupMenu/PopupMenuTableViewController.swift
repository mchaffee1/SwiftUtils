//
//  PopupMenuTableViewController.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit

protocol PopupMenuTableViewControllerDelegate: class {
  func popupMenuVCDismissed(selection: String)
}

class PopupMenuTableViewController: UITableViewController {
  var delegate: PopupMenuTableViewControllerDelegate?
  
  var values = ["One", "Two"]
  var selectedValue = ""
  var suppressDidDisappear = false
  
  private let bundleIdentifier = "com.chaf.SwiftUtils"
  private let cellIdentifier = "PopupMenuTableViewCell"
  
  convenience init() {
    self.init(nibName: "PopupMenuTableViewController", bundle: NSBundle(identifier: "com.chaf.SwiftUtils"))
    tableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle(identifier: bundleIdentifier)), forCellReuseIdentifier: cellIdentifier)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    var cell: PopupMenuTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? PopupMenuTableViewCell
    
    //    if cell == nil {
    //      tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    //      cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? PopupMenuTableViewCell
    //    }
    
    cell.value = value
    cell.viewController = self
    
    return cell
  }
  
  override func viewDidDisappear(animated: Bool) {
    if !suppressDidDisappear {
      self.delegate?.popupMenuVCDismissed("")
    }
  }
  
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
