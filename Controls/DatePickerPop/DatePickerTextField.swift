//
//  DatePickerTextField.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/// This custom control is a read-only UITextField which, when touched, raises a DatePickerPop and, after user entry,
/// places that picker's value in its own text with its dateStyle property's style.
/// To use:
/// - Wire the popupContainer outlet to the view controller which should contain the popup.
/// - Wire the valueChanged event to the appropriate receiver AND/OR assign a delegate to receive textFieldDidEndEditing calls.
/// - (optional) Set the dateStyle property if something other than .ShortStyle is desired.
import UIKit

public class DatePickerTextField: UITextField {
  
  // IMPORTANT:  This outlet is how we access the view controller which should render
  // the popup.  If the viewController outlet isn't wired up to a view controller (usually this control's parent VC),
  // then the popup won't appear.
  @IBOutlet weak var popupContainer: UIViewController!
  
  // The date contained in the text field.
  // Any time it changes, the delegate is notified (meaning the delegate may need to filter the event from initial population).
  public var date: NSDate! {
    get { return _date }
    set {
      if newValue != _date {
        _date = newValue
        renderDate()
        sendValueChanged()
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
  
  private var overButton: UIButton!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // Create a button that lies on top of the textview.  
  // The button thus handles the touch interaction (simple touchUpInside)
  private func initDateControl() {
    let myFrame = self.bounds
    overButton = UIButton(type: .System)
    overButton.frame = CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height)
    overButton.addTarget(self, action: Selector("overButton_touchUpInside:"), forControlEvents:[.TouchUpInside])
    self.addSubview(overButton)
  }
  
  // Call initDateControl() at layout-time.
  override public func layoutSubviews() {
    super.layoutSubviews()
    initDateControl()
  }
  
  // take the value stored in the date property, and display it in the text field.
  private func renderDate() {
    var dateText = ""
    defer { text = dateText }
    
    if date != nil {
      dateText = NSDateFormatter.localizedStringFromDate(date, dateStyle: self.dateStyle, timeStyle: .NoStyle)
    }
  }
  
  // Send ValueChanged and EditingDidEnd events to the receiver (if assigned)
  // and call the delegate's didFinishEditing method (if available).
  private func sendValueChanged() {
    sendActionsForControlEvents([.ValueChanged, .EditingDidEnd, .EditingChanged])
    delegate?.textFieldDidEndEditing?(self)
  }
  
  // Actually pop up a picker, then update date from picked value.
  public func popUp() {
    if popupContainer == nil {
      return;
    }
    
    self.resignFirstResponder()
    
    if datePickerPop == nil {
      datePickerPop = DatePickerPop(forTextField: self)
    }
    
    let dataChangedCallback : DatePickerPop.DatePickerPopCallback = { (newDate : NSDate, forTextField : DatePickerTextField) -> () in
      
      forTextField.date = newDate
    }
    
    datePickerPop.pick(popupContainer, initDate: self.date, dataChanged: dataChangedCallback)
    
  }
  
  // Receiver for the touchUpInside sent from overButton.
  func overButton_touchUpInside(sender: AnyObject) {
    popUp()
  }
}