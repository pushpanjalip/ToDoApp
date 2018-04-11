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
    
    //MARK:Create plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        saveData()
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
            self.saveData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:Saving data to plist
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do{
           let data = try encoder.encode(items)
            //write data to file
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Eroor encoding data:\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:Loading Data
    func loadData() {
        if let data = try? Data(contentsOf:dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding data \(error)")
            }
        }
        
    }
}

