//
//  FirstViewController.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/16/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit
import CoreData

class TodosViewController: UIViewController {
    
    var todos: [Todo] = []
    var managedContextObject: NSManagedObjectContext!
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        managedContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        prepareUI()
        loadTodos(sort: nil)
        createTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTodos(sort: nil)
    }
    
    @objc func handleAdd() {
        let backButton = UIBarButtonItem()
        backButton.title = "Cancel"
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        let addVC = self.storyboard!.instantiateViewController(withIdentifier: "AddTodoViewController")
        show(addVC as! AddTodoViewController, sender: self)
    }
    
    @objc func handleOptions() {
        let actionSheet = UIAlertController(title: "Sort", message: "How do you want to sort your todos?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let name = UIAlertAction(title: "By name", style: .default) { action in
            self.loadTodosBy(sortingMethod: "text")
        }
        let date = UIAlertAction(title: "By date", style: .default) { action in
            self.loadTodosBy(sortingMethod: "date")
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(name)
        actionSheet.addAction(date)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func loadTodosBy(sortingMethod: String) {
        let sort = NSSortDescriptor(key: "\(sortingMethod)", ascending: true)
        loadTodos(sort: sort)
    }
    
    func loadTodos(sort: NSSortDescriptor?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        let predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        fetchRequest.predicate = predicate
        if let sortingMethod = sort {
            fetchRequest.sortDescriptors = [sortingMethod]
        }
        do {
            if let results = try managedContextObject.fetch(fetchRequest) as? [Todo] {
                todos = results
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
                results![0].setValue(NSNumber(value: true), forKey: "completed")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        saveToPersistentContainer()
    }

}

//delegate and data source for the table view
extension TodosViewController : UITableViewDataSource, UITableViewDelegate, TodoTableViewCellDelegate {
    func todoTableViewCellDidTapCheck(_ sender: TodoTableViewCell) {
        sender.checkButton.isSelected = true
        if let task = sender.todo {
            updateRecord(todo: task)
        }
        loadTodos(sort: nil)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.todo = todos[indexPath.row]
        cell.checkButton.isSelected = false
        cell.todoTextView.attributedText = NSAttributedString(string: cell.todo!.text!, attributes: attributesForText)
        cell.dateTextView.attributedText = NSAttributedString(string: "Due on: \(cell.todo!.date!.toString(dateFormat: "yyyy-MM-dd HH:mm"))", attributes: attributesForDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        if editingStyle == UITableViewCellEditingStyle.delete {
            managedContextObject.delete(todo)
            saveToPersistentContainer()
            loadTodos(sort: nil)
            tableView.reloadData()
        }
    }
}

//prepare UI extension
extension TodosViewController {
    private func prepareUI() {
        view.layer.insertSublayer(createGradient(bounds: view.bounds), at: 0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 71/255, green: 59/255, blue: 207/255, alpha: 1)
        navigationItem.title = "Todos"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        setupNavBarButtons()
    }
    
    private func setupNavBarButtons(){
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        let optionsImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let optionsBarButtonItem = UIBarButtonItem(image: Helper.resizeImage(image: optionsImage!, targetSize: iconSize), style: .plain, target: self, action: #selector(handleOptions))
        navigationItem.rightBarButtonItems = [addBarButtonItem, optionsBarButtonItem]
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

