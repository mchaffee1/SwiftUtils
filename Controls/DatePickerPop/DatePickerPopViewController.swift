//
//  DatePickerActionSheet.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 30/09/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate : class {
    
    func datePickerVCDismissed(date : NSDate?)
}

class DatePickerPopViewController : UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate : DatePickerViewControllerDelegate?

    var currentDate : NSDate? {
        didSet {
            updatePickerCurrentDate()
        }
    }

    convenience init() {

        self.init(nibName: "DatePickerPopViewController", bundle: NSBundle(identifier: "com.chaf.SwiftUtils"))
    }

    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _datePicker = self.datePicker {
                _datePicker.date = _currentDate
            }
        }
    }

    @IBAction func okAction(sender: AnyObject) {
      
        self.dismissViewControllerAnimated(true) {
            
            let nsdate = self.datePicker.date
            self.delegate?.datePickerVCDismissed(nsdate)
            
        }
    }
    
    override func viewDidLoad() {
        
        updatePickerCurrentDate()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.datePickerVCDismissed(nil)
    }
}
