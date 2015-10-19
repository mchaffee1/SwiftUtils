//
//  PopupMenu.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit

public class PopupMenu: NSObject, UIPopoverPresentationControllerDelegate, PopupMenuTableViewControllerDelegate {
  
  public typealias PopupMenuCallback = (selection: String)->()
  
  var popupMenuTableViewController: PopupMenuTableViewController
  var popover: UIPopoverPresentationController?
  var selectionReceived: PopupMenuCallback?
  var presented = false
  var offset: CGFloat = 8.0
  var receivedSelection = ""
  var callback: PopupMenuCallback?
  
  public override init() {
    popupMenuTableViewController = PopupMenuTableViewController()
    super.init()
  }
  
  
  // TODO:  Consolidate these show() operations into one method.
  public class func show(forSourceView sourceView: UIView, inViewController viewController: UIViewController, withButtons buttons: String..., completion: PopupMenuCallback?) {
    PopupMenu.show(withAttachment: {(popup: PopupMenu) ->() in
      if let pop = popup.popover {
        pop.sourceView = sourceView
        pop.sourceRect = CGRectMake(popup.offset, sourceView.bounds.size.height, 0, 0)
      }
      }, inViewController: viewController, withButtons: buttons, completion: completion)
  }
  
  public class func show(forBarButton barButton: UIBarButtonItem, inViewController viewController: UIViewController, withButtons buttons: String..., completion: PopupMenuCallback?) {
    PopupMenu.show(withAttachment: {(popup: PopupMenu) ->() in
      if let pop = popup.popover {
        pop.barButtonItem = barButton
      }
      }, inViewController: viewController, withButtons: buttons, completion: completion)
  }
  
  // Private class show() to do all the shared stuff for show(forBarButton:) and show(forSourceView:)
  private class func show(withAttachment attachment: (popup: PopupMenu)->(), inViewController: UIViewController, withButtons buttons: [String], completion: PopupMenuCallback?) {
    let popup = PopupMenu()
    
    if popup.presented { return }
    
    let controller = popup.popupMenuTableViewController
    controller.delegate = popup
    controller.modalPresentationStyle = UIModalPresentationStyle.Popover
    controller.preferredContentSize = CGSizeMake(500, 208)
    controller.values = buttons
    
    popup.callback = completion
    popup.popover = controller.popoverPresentationController
    if let _popover = popup.popover {
      attachment(popup: popup)
      _popover.delegate = popup
      inViewController.presentViewController(controller, animated: true, completion: nil)
      popup.presented = true
    }
  }
  
  public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  
  func popupMenuVCDismissed(selection: String) {
    callback?(selection: selection)
    presented = false
  }
}
