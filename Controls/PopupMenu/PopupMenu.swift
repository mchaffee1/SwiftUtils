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

// TODO:  This needs SO MUCH code cleanup.

public class PopupMenu: NSObject {
  
  // Signature of the callback that the caller should pass to the show method
  public typealias PopupMenuCallback = (selection: String)->()
  
  public var font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

  private var popupMenuTableViewController: PopupMenuTableViewController
  private var popover: UIPopoverPresentationController?
  var presented = false  // True when the menu is showing.
  var callback: PopupMenuCallback?  // callback passed in for completion of the menu operation.
  let offset: CGFloat = 8.0
  
  public override init() {
    popupMenuTableViewController = PopupMenuTableViewController()
    super.init()
  }
  
  
  // class function to do a simple show for
  public class func show(forSourceView sourceView: UIView, inViewController viewController: UIViewController, withButtons buttons: String..., completion: PopupMenuCallback?) {
    PopupMenu().show(forSourceView: sourceView, inViewController: viewController, withButtons: buttons, completion: completion)
  }

  public func show(forSourceView sourceView: UIView, inViewController viewController: UIViewController, withButtons buttons: [String], completion: PopupMenuCallback?) {
    show(withAttachment: {(popup: PopupMenu) ->() in
      if let pop = popup.popover {
        pop.sourceView = sourceView
        pop.sourceRect = CGRectMake(popup.offset, sourceView.bounds.size.height, 0, 0)
      }
      }, inViewController: viewController, withButtons: buttons, completion: completion)
  }
  
  public class func show(forBarButton barButton: UIBarButtonItem, inViewController viewController: UIViewController, withButtons buttons: String..., completion: PopupMenuCallback?) {
    PopupMenu().show(forBarButton: barButton, inViewController: viewController, withButtons: buttons, completion: completion)
  }

  public func show(forBarButton barButton: UIBarButtonItem, inViewController viewController: UIViewController, withButtons buttons: [String], completion: PopupMenuCallback?) {
    show(withAttachment: {(popup: PopupMenu) ->() in
      if let pop = popup.popover {
        pop.barButtonItem = barButton
      }
      }, inViewController: viewController, withButtons: buttons, completion: completion)
  }
  
  // Private class show() to do all the shared stuff for show(forBarButton:) and show(forSourceView:)
  private func show(withAttachment attachment: (popup: PopupMenu)->(), inViewController: UIViewController, withButtons buttons: [String], completion: PopupMenuCallback?) {
    if presented { return }
    
    let controller = popupMenuTableViewController
    controller.delegate = self
    controller.modalPresentationStyle = UIModalPresentationStyle.Popover
    controller.font = font
//     controller.preferredContentSize = CGSizeMake(100, 80)
    controller.values = buttons
    controller.view.setNeedsLayout()
    controller.view.layoutIfNeeded()
//    CGFloat width = 200.0;
    let height = controller.tableView.rectForSection(0).height
    
    var width: CGFloat = 0.0
    let constraintRect = CGSizeMake(9999, 9999)
    for button in buttons {
      let boundingBox = button.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
      if boundingBox.width > width {
        width = boundingBox.width + 5
      }
    }
    
    controller.preferredContentSize = CGSizeMake(width, height)
    callback = completion
    popover = controller.popoverPresentationController
    if let _popover = popover {
      attachment(popup: self)
      _popover.delegate = self
      inViewController.presentViewController(controller, animated: true, completion: nil)
      presented = true
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
