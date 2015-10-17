//
//  DatePickerTextField.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/*
This custom control is a read-only UITextField which, when touched, raises a DatePickerPop and, after user entry,
places that picker's value in its own text with its dateStyle property's style.
*/
import UIKit

public class DatePickerTextField: UITextField {

  // IMPORTANT:  This outlet is how we access the view controller which should render
  // the popup.  If the viewController outlet isn't wired up to a view controller (usually this control's parent VC),
  // then the popup won't appear.
  @IBOutlet weak var viewController: UIViewController!
  
  public var date: NSDate! {
    didSet { renderDate() }
  }
  
  public var dateStyle: NSDateFormatterStyle = .ShortStyle {
    didSet { renderDate() }
  }
  
  private var datePickerPop: DatePickerPop!
  
  private func renderDate() {
    var dateText = ""
    defer { text = dateText }
    
    if date != nil {
      dateText = date.toString(dateStyle: self.dateStyle, timeStyle: .NoStyle)
    }
  }
  
  public func pop() {
    if viewController == nil {
      return;
    }
    
    let dataChangedCallback : DatePickerPop.DatePickerPopCallback = { (newDate : NSDate, forTextField : DatePickerTextField) -> () in
      
      forTextField.date = newDate
    }
    
    datePickerPop.pick(viewController, initDate: self.date, dataChanged: dataChangedCallback)

  }
  
  private func popFromTouch() {
    
  }
}
