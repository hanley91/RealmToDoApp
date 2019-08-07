//
//  ViewController.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import UIKit
import RealmSwift

protocol DateUpdateDelegate {
    func update(date:Date)
}

class MainToDoViewController: UIViewController, MainToDoViewDelegate, UITableViewDelegate, DateUpdateDelegate {
    
    //MARK: View Properties
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var prioritySelector:UISegmentedControl!
    @IBOutlet weak var dueDateSelectButton:UIButton!
    @IBOutlet weak var todoLister:UITableView!
    
    private let mainToDoPresenter = MainToDoPresenter()
    private let todoDatasource = MainToDoDatasource()
    
    var notificationToken: NotificationToken?

    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainToDoPresenter.setViewDelegate(mainToDoDelegate: self)
        todoLister.dataSource = todoDatasource
        todoLister.delegate = self
        
        mainToDoPresenter.setDateButtonTitleToToday()
        
        self.notificationToken = todoDatasource.searchResults.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.todoLister.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.todoLister.beginUpdates()
                self.todoLister.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.todoLister.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.todoLister.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.todoLister.endUpdates()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        }
    }
    
    //MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteActionFor(table: tableView, row:indexPath.row, section: indexPath.section)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editActionFor(row: indexPath.row, section: indexPath.section)
        }
        
        edit.backgroundColor = UIColor.blue
        
        
        return [delete, edit]
        
    }
    
    func deleteActionFor(table: UITableView, row: Int, section: Int){
        let confirm = UIAlertController(title: "Delete ToDo", message: "Are You Sure? Once you delete this, it cannot be recovered.", preferredStyle: .alert)
        
        let yesOption = UIAlertAction(title: "Delete", style: .destructive, handler:{ (action) in
            self.deleteLinkAt(row: row, section: section, table: table)
        })
        
        let noOption = UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action) in
            confirm.dismiss(animated: true, completion: nil)
        })
        
        confirm.addAction(noOption)
        confirm.addAction(yesOption)
        
        present(confirm, animated: true, completion: nil)
    }
    
    func deleteLinkAt(row:Int, section:Int, table:UITableView){
        let toDelete = todoDatasource.searchResults[row]
        mainToDoPresenter.delete(todo: toDelete)
    }
    
    func editActionFor(row:Int,section:Int){
        let toEdit = todoDatasource.searchResults[row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditExisting") as! EditToDoViewController
        vc.todo = toEdit
        vc.preferredContentSize = CGSize(width: self.view.frame.width-20, height: 500)
        
        let segue = BottomCard(identifier: nil, source: self, destination: vc)
        prepare(for: segue, sender: nil)
        segue.perform()
    }
    
    //MARK: View IBActions
    @IBAction func saveNewToDoItem(){
        mainToDoPresenter.addNewToDoItem()
    }
    
    @IBAction func updateTitle(sender:UITextField){
        if let text = sender.text{
            mainToDoPresenter.changeTitle(newTitle: text)
        }else{
            mainToDoPresenter.changeTitle(newTitle: "")
        }
    }
    
    @IBAction func togglePriority(sender:UISegmentedControl){
        let selectedSegment = sender.selectedSegmentIndex
        mainToDoPresenter.changePriority(selectedPriority: selectedSegment)
    }
    
    @IBAction func selectDate(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DateSelection") as! DueDateSelectionViewController
        vc.dateDelegate = self
        vc.preferredContentSize = CGSize(width: self.view.frame.width-20, height: 500)
        
        let segue = BottomCard(identifier: nil, source: self, destination: vc)
        prepare(for: segue, sender: nil)
        segue.perform()
    }
    
    //MARK: View Delegate Methods
    func showValidationError(errorController:UIAlertController){
        present(errorController, animated: true, completion: nil)
    }
    
    func updateDateButton(title:String){
        dueDateSelectButton.setTitle(title, for: .normal)
    }
    
    func resetToDoForm() {
        titleField.text = ""
        prioritySelector.selectedSegmentIndex = 0
        
        mainToDoPresenter.setDateButtonTitleToToday()
    }
    
    //MARK: Date Update Delegate Methods
    func update(date: Date) {
        mainToDoPresenter.changeDueDate(newDate: date)
    }


}

