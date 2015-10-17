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
  
  private var startTouch = CGPoint()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
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
    
    if datePickerPop == nil {
      datePickerPop = DatePickerPop(forTextField: self)
    }
    
    let dataChangedCallback : DatePickerPop.DatePickerPopCallback = { (newDate : NSDate, forTextField : DatePickerTextField) -> () in
      
      forTextField.date = newDate
    }
    
    datePickerPop.pick(viewController, initDate: self.date, dataChanged: dataChangedCallback)

  }
  
  private func setDateFromPop(newDate: NSDate) {
    if date != newDate {
      date = newDate
      if let dateDelegate = delegate as? DatePickerTextFieldDelegate {
        dateDelegate.datePickerDateDidChange(self)
      }
    }
  }
  
  private func popFromTouch() {
    self.resignFirstResponder()
    pop()
  }
  
  override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    popFromTouch()
//    startTouch = touch.locationInView(nil)
//    NSLog("beginTrackingWithTouch: %f, %f", touch.locationInView(nil).x, touch.locationInView(nil).y)
    return false
  }
  
  override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    if let theTouch = touch {
      let touchedUpInside = self.frame.contains(theTouch.locationInView(nil))
      NSLog("endTrackingWithTouch: %f, %f; %@", theTouch.locationInView(nil).x, theTouch.locationInView(nil).y, touchedUpInside)
    }
  }
}
