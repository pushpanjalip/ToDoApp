//
//  ViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/9/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = ["Lotus","Rose","Jasmine","Orchid"]
    //MARK:UserDefaults initialization
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrieve the value stored in UserDefaults
        if let itemsArray = defaults.array(forKey: "TodoList") as? [String] {
            items = itemsArray
        }
        
        
    }
    
    
    //MARK:TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        cell.textLabel?.text = items[indexPath.item]
        return cell
    }
    
    //MARK:TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:Add New Item
    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertTextField) in
            if let item = alert.textFields?.first?.text {
            self.items.append(item)
                //MARK:Setting UserDefaults Value
            self.defaults.set(self.items, forKey: "TodoList")
            self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

