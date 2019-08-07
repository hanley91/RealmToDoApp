//
//  EditToDoViewController.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-05.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import UIKit

class EditToDoViewController: UIViewController, EditToDoViewDelegate, DateUpdateDelegate {
    
    //MARK: View Properties
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var prioritySelector:UISegmentedControl!
    @IBOutlet weak var dateSelectionButton:UIButton!
    
    private let editPresenter = EditToDoPresenter()
    var todo:ToDoItem!

    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        editPresenter.setViewDelegate(editDelegate: self)
        editPresenter.setTodoItem(existing: todo)
        editPresenter.loadTitle()
        editPresenter.loadDueDateString()
        editPresenter.loadSelectedPriority()
    }
    
    //MARK: View Actions
    @IBAction func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(){
        editPresenter.updateTodo()
    }
    
    @IBAction func changeDateValue(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DateSelection") as! DueDateSelectionViewController
        vc.dateDelegate = self
        vc.preferredContentSize = CGSize(width: self.view.frame.width-20, height: 500)
        
        let segue = BottomCard(identifier: nil, source: self, destination: vc)
        prepare(for: segue, sender: nil)
        segue.perform()
    }
    
    @IBAction func updateTitle(sender:UITextField){
        if let text = sender.text{
            editPresenter.changeTitle(newTitle: text)
        }else{
            editPresenter.changeTitle(newTitle: "")
        }
    }
    
    @IBAction func changePriority(sender:UISegmentedControl){
        let selectedSegment = sender.selectedSegmentIndex
        editPresenter.changePriority(selectedPriority: selectedSegment)
    }
    
    //MARK: View Delegate Methods
    func dismissViewOnUpdate() {
        dismissView()
    }
    
    func showValidationError(errorController:UIAlertController){
        present(errorController, animated: true, completion: nil)
    }
    
    func set(title: String) {
        titleField.text = title
    }
    
    func setDate(label: String) {
        dateSelectionButton.setTitle(label, for: .normal)
    }
    
    func setPriority(index: Int) {
        prioritySelector.selectedSegmentIndex = index
    }
    
    //MARK: Date Update Delegate Methods
    func update(date: Date) {
        editPresenter.changeDueDate(date: date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
