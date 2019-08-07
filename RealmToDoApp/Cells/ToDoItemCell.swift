//
//  ToDoItemCell.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dueDateLabel:UILabel!
    @IBOutlet weak var priorityLabel:UILabel!
    
    //MARK: View Model
    var todo:ToDoItemCellModel!{
        didSet{
            if todo != nil{
                titleLabel.text = todo.getTitle()
                dueDateLabel.text = todo.getFormattedDateString()
                priorityLabel.text = todo.getPriority()
            }else{
                titleLabel.text = nil
                dueDateLabel.text = nil
                priorityLabel.text = nil
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        todo = nil
    }

}
