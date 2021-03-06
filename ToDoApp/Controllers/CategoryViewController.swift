//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/12/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>?
    var realm: Realm?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        realm  = try! Realm()
         loadCategories()
    }
    //MARK: TableView DataSource Methods
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category Added Yet"
        let backgroundColor = UIColor(hexString: category?.colour ?? "17977D")
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: backgroundColor!, returnFlat: true)
        return cell
    }
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowToDoList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowToDoList" {
            let destinationVC = segue.destination as! TodoListViewController
            //get the index path for selected category
           if let selectedIndexPath = tableView.indexPathForSelectedRow{
            let selectedCategory = categories?[(selectedIndexPath.item)]
            destinationVC.selectedCategory = selectedCategory
            }
        }
    }
    
    //MARK: Add Category
    @IBAction func addCategoryPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Add New Category"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save Data
    func save(category: Category) {
        do{
            try realm?.write {
                realm?.add(category)
            }
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    //MARK: Load Data
    func loadCategories(){
        categories =  realm?.objects(Category.self)
            tableView.reloadData()
    }
    //MARK: Delete Data
    override func updateItem(at IndexPath: IndexPath) {
        if let categoryForDeletion = categories?[IndexPath.row]{
            do{
                try realm?.write {
                    realm?.delete(categoryForDeletion)
                }
            }catch{
                print("Error Deleting Category \(error)")
            }
        }
    }
}
