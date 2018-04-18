//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/12/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var categories: Results<Category>?
    var realm: Realm?
    override func viewDidLoad() {
        super.viewDidLoad()
        realm  = try! Realm()
         loadCategories()
    }
    //MARK: TableView DataSource Methods
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?.name ?? "No Category Added Yet"
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
    
    
}
