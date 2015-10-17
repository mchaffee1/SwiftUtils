//
//  DataPicker.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 30/09/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import UIKit

public class DatePickerPop : NSObject, UIPopoverPresentationControllerDelegate, DatePickerViewControllerDelegate {
    
    public typealias DatePickerPopCallback = (newDate : NSDate, forTextField : UITextField)->()
    
    var datePickerVC : DatePickerPopViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : DatePickerPopCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        datePickerVC = DatePickerPopViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSDate?, dataChanged : DatePickerPopCallback) {
        
        if presented {
            return  // we are busy
        }
        
        datePickerVC.delegate = self
        datePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        datePickerVC.preferredContentSize = CGSizeMake(500,208)
        datePickerVC.currentDate = initDate
        
        popover = datePickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(datePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func datePickerVCDismissed(date : NSDate?) {
        
        if let _dataChanged = dataChanged {
            
            if let _date = date {
            
                _dataChanged(newDate: _date, forTextField: textField)
        
            }
        }
        presented = false
    }
}
