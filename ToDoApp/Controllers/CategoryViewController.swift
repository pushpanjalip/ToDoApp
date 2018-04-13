//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Abhijeet mane on 4/12/18.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name
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
            let selectedCategory = categories[(selectedIndexPath.item)]
            destinationVC.selectedCategory = selectedCategory
            }
        }
    }
    
    //MARK: Add Category
    @IBAction func addCategoryPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categories.append(newCategory)
                self.saveData()
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Add New Category"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save Data
    func saveData() {
        do{
            try context.save()
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    //MARK: Load Data
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
    
    
}
