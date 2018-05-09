//
//  ViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/9/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var items: Results<Item>?
    var realm: Realm?
    //MARK: using didSet
    var selectedCategory: Category? {
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        realm = try! Realm()
    }
    
    
    //viewWillAppear gets called after viewDidLoad so to be sure that TodoListViewController is added to navigation stack
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let hexCode = selectedCategory?.colour else {fatalError()}
        updateNavBar(withHexColor: hexCode)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexColor: "17977D")
    }
    
    //Mark: Update Navbar
    func updateNavBar(withHexColor barColour: String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navbar does not exist")
        }
        guard let barColor = UIColor(hexString: barColour) else {
            fatalError()
        }
        navBar.barTintColor = barColor
        let tintColor = ContrastColorOf(backgroundColor: barColor, returnFlat: true)
        navBar.tintColor = tintColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: tintColor]
        
    }
    //MARK:TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory?.colour).darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "no Items Added Yet"
        }
        return cell
    }

    //MARK:TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm?.write{
                    item.done = !item.done
                }
            }catch{
                print("Error updating item \(error)")
            }
            tableView.reloadData()
        }
    }

    
    //MARK:Add New Item
    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let title = alert.textFields?.first?.text {
                if let selectedCategory = self.selectedCategory{
                    //Add and Save Item
                    do{
                        try self.realm?.write {
                            let newItem = Item()
                            newItem.title = title
                            selectedCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error saving data to Realm \(error)")
                    }
                }
               self.tableView.reloadData()
        }
        
       
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:Loading Items
    func loadItems() {
       items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
 }
    //MARK: Deleting TodoItem
    override func updateItem(at IndexPath: IndexPath) {
        if let itemForDeletion = items?[IndexPath.row] {
            do{
                try realm?.write {
                    realm?.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting Item")
            }
        }
    }
}

//MARK:Searching Data

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

