//
//  CategoryViewController.swift
//  Todo
//
//  Created by Peter Emel on 1/20/20.
//  Copyright © 2020 Peter Emel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //Variables
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //outlets
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    
    //Mark: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    func saveCategories() {
        do{
            try context.save()
        }catch{
            print("Error Saving Categories Context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error Loading Categories Context \(error)")
        }
        tableView.reloadData()
    }
    
    
    //Mark: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
