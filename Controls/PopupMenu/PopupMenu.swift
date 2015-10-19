//
//  PopupMenu.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/18/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/* 
This class raises a popup menu with the specified button texts, and passes back the button text of the selected
item, or else an empty string if no selection is made.

To use: just call class func show(forSourceView:...) or show(forBarButton:...) with a callback that processes the user
input.
*/

import UIKit

public class PopupMenu: NSObject {
  
  // Signature of the callback that the caller should pass to the show method
  public typealias PopupMenuCallback = (selection: String)->()

  private var popupMenuTableViewController: PopupMenuTableViewController
  private var popover: UIPopoverPresentationController?
  var presented = false  // True when the menu is showing.
  var callback: PopupMenuCallback?  // callback passed in for completion of the menu operation.
  let offset: CGFloat = 8.0
  
  public override init() {
    popupMenuTableViewController = PopupMenuTableViewController()
    super.init()
  }
  
  
  // The two public show functions are designed to be called by a consuming application.
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
}

// MARK: - UIPopoverPresentationControllerDelegate
extension PopupMenu: UIPopoverPresentationControllerDelegate {
  public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
}

// MARK: - PopupMenuTableViewControllerDelegate conformance
extension PopupMenu: PopupMenuTableViewControllerDelegate {
  func popupMenuVCDismissed(selection: String) {
    callback?(selection: selection)
    presented = false
  }
}
