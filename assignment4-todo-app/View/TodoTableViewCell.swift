//
//  TodoTableViewCell.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/17/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate : class {
    func todoTableViewCellDidTapCheck(_ sender: TodoTableViewCell)
}

class TodoTableViewCell: UITableViewCell {
    
    var todo: Todo?
    
    weak var delegate: TodoTableViewCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    let todoTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        let unselectedImage = UIImage(named: "uncheck")
        let selectedImage = UIImage(named: "check")
        button.setImage(Helper.resizeImage(image: unselectedImage!, targetSize: iconSize), for: .normal)
        button.setImage(Helper.resizeImage(image: selectedImage!, targetSize: iconSize), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dateTextView: UITextView = {
       let textView = UITextView()
        textView.text = "date goes here"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    
    @objc func buttonTapped() {
        self.delegate?.todoTableViewCellDidTapCheck(self)
    }
    
    func setupViews() {
        addSubview(todoTextView)
        addSubview(checkButton)
        addSubview(dateTextView)
        
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
        
        //checkImageView constrains
        addConstraint(NSLayoutConstraint(item: checkButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: checkButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        checkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //todoTextView constrains
        addConstraint(NSLayoutConstraint(item: todoTextView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: todoTextView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: todoTextView, attribute: .right, relatedBy: .equal, toItem: checkButton, attribute: .left, multiplier: 1, constant: -15))
        
        //dateTextView
        addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .top, relatedBy: .equal, toItem: todoTextView, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .right, relatedBy: .equal, toItem: checkButton, attribute: .left, multiplier: 1, constant: -15))
        addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -15))
    }

}
