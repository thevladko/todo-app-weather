//
//  SecondViewController.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/16/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit
import CoreData

class CompletedViewController: UIViewController {
    
    var completedTodos: [Todo] = []
    let tableView = UITableView()
    var managedContextObject: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        managedContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        prepareUI()
        createTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTodos()
        tableView.reloadData()
    }
    
    func loadTodos() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        let predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            if let results = try managedContextObject.fetch(fetchRequest) as? [Todo] {
                completedTodos = results
                tableView.reloadData()
            }
        } catch {
            print("error \(error.localizedDescription)")
        }
    }
    
    func saveToPersistentContainer() {
        do {
            try managedContextObject.save()
        } catch {
            print("Could not resave data \(error.localizedDescription)")
        }
    }
    
    func updateRecord(todo: Todo) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "text = %@", "\(todo.text!)")
        do {
            let results = try managedContextObject.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(NSNumber(value: false), forKey: "completed")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        saveToPersistentContainer()
    }
}

extension CompletedViewController : UITableViewDataSource, UITableViewDelegate, TodoTableViewCellDelegate {
    func todoTableViewCellDidTapCheck(_ sender: TodoTableViewCell) {
        sender.checkButton.isSelected = false
        if let task = sender.todo {
            updateRecord(todo: task)
        }
        loadTodos()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.todo = completedTodos[indexPath.row]
        cell.checkButton.isSelected = true
        cell.todoTextView.attributedText = NSAttributedString(string: cell.todo!.text!, attributes: attributesForText)
        cell.dateTextView.attributedText = NSAttributedString(string: "Due on: \(cell.todo!.date!.toString(dateFormat: "yyyy-MM-dd HH:mm"))", attributes: attributesForDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let todo = completedTodos[indexPath.row]
        if editingStyle == UITableViewCellEditingStyle.delete {
            managedContextObject.delete(todo)
            saveToPersistentContainer()
            loadTodos()
            tableView.reloadData()
        }
    }
}

extension CompletedViewController {
    func prepareUI() {
        view.layer.insertSublayer(createGradient(bounds: view.bounds), at: 0)
        navigationItem.title = "Completed"
    }
    
    private func createTableView(){
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.delegate = self
        tableView.dataSource = self
        customizingTableView()
        view.addSubview(tableView)
    }
    
    private func customizingTableView(){
        tableView.separatorColor = UIColor(red: 203/255, green: 201/255, blue: 218/255, alpha: 1)
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = LineView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
}

