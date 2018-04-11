//
//  ViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/9/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = [Item]()   //[]
    //var items = [Item()]    =>[{title "" done false}]  will create blank row in table view
    //MARK:UserDefaults initialization
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item()
        newItem.title = "create excelsheet"
        items.append(newItem)
        let newItem1 = Item()
        newItem1.title = "Add Data"
        items.append(newItem1)
        let newItem2 = Item()
        newItem2.title = "learn swift"
        items.append(newItem2)
        
        //retrieve the value stored in UserDefaults
        if let itemsArray = defaults.array(forKey: "TodoList") as? [Item] {
            items = itemsArray
        }
        
        
    }
    
    
    //MARK:TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        let item = items[indexPath.item]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK:TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       items[indexPath.row].done = !items[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:Add New Item
    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertTextField) in
            if let title = alert.textFields?.first?.text {
                let newItem = Item()
                newItem.title = title
            self.items.append(newItem)
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

