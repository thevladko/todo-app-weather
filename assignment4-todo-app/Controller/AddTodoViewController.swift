//
//  AddTodoViewController.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/17/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    var managedContextObject: NSManagedObjectContext!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBAction func addTodo(_ sender: Any) {
        if let text = todoTextField.text {
            if text == "" {
                alert()
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContextObject)!
                let todo = Todo(entity: entity, insertInto: managedContextObject)
                todo.completed = false
                todo.text = text
                todo.date = datePicker.date
                do {
                    try managedContextObject.save()
                } catch {
                    print("Error has occured when saving data to database \(error.localizedDescription)")
                }
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "Nothing todo?", message: "Todo TextField cannot be empty!", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil )
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        todoTextField.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AddTodoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
