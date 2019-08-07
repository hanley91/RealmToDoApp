//
//  DueDateSelectionViewController.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import UIKit

class DueDateSelectionViewController: UIViewController{
    
    //MARK: View Controller Properties
    @IBOutlet weak var datePicker:UIDatePicker!
    var dateDelegate:DateUpdateDelegate?

    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Date()
    }
    
    //MARK: View Actions
    @IBAction func updateSelectedDate(sender:UIDatePicker) {
        let date = sender.date
        dateDelegate?.update(date: date)
    }
    
    @IBAction func dismissView(){
        dismiss(animated: true, completion: {
            self.dateDelegate = nil
        })
    }

}
