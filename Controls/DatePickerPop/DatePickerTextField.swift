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
  
  // The date contained in the text field.
  // Any time it changes, the delegate is notified (meaning the delegate may need to filter the event from initial population).
  public var date: NSDate! {
    get { return _date }
    set {
      if newValue != _date {
        _date = newValue
        renderDate()
        if let dateDelegate = delegate as? DatePickerTextFieldDelegate {
          dateDelegate.datePickerDateDidChange(self)
        }
      }
    }
  }

  // Style in which to render the date.
  public var dateStyle: NSDateFormatterStyle = .ShortStyle {
    didSet { renderDate() }
  }
  
  // Privately stored "real" date, mostly so initialization doesn't cause unnecessary delegate callbacks.
  private var _date: NSDate!
  
  private var datePickerPop: DatePickerPop!
  
  private var startTouch = CGPoint()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // take the value stored in the date property, and display it in the text field.
  private func renderDate() {
    var dateText = ""
    defer { text = dateText }
    
    if date != nil {
      dateText = date.toString(dateStyle: self.dateStyle, timeStyle: .NoStyle)
    }
  }

  // Actually pop up a picker, then update date from picked value.
  public func pop() {
    if viewController == nil {
      return;
    }
    
    self.resignFirstResponder()

    if datePickerPop == nil {
      datePickerPop = DatePickerPop(forTextField: self)
    }
    
    let dataChangedCallback : DatePickerPop.DatePickerPopCallback = { (newDate : NSDate, forTextField : DatePickerTextField) -> () in
      
      forTextField.date = newDate
    }
    
    datePickerPop.pick(viewController, initDate: self.date, dataChanged: dataChangedCallback)

  }
  
  override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    pop()
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
