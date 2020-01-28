//
//  CategoryViewController.swift
//  Todo
//
//  Created by Peter Emel on 1/20/20.
//  Copyright © 2020 Peter Emel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //Variables
    var categories : Results<Category>?
    let realm = try! Realm()
    
    //outlets
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    
    //Mark: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categoryIndexPath = categories?[indexPath.row] {
            cell.textLabel?.text = categoryIndexPath.name ?? "No Categories Added Yet"
        
            guard let categoryColour = UIColor(hexString: categoryIndexPath.cellColour) else{fatalError()}
        
            cell.backgroundColor = UIColor(hexString: categoryIndexPath.cellColour)
        
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)

        }
        return cell
    }
    
    //Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    func save(category:Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving Categories Context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //Mark: - Delet Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
      
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    //Mark: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.cellColour = UIColor.randomFlat.hexValue()
                        
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
