//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rihab Al-yasiri on 04.03.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    // saving all Categories here to update the UI and no need to fetch them from Database whenever I nned them
    var categoryArray: Results<Category>?
    
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // to get path File where SQLite saved
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
 

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }
    
    // to show the content of list on the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell with dequeueReusableCell()
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // show data on the cell and return it
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added"
        
        //changing color of cell randomly
        if let colorCell = categoryArray?[indexPath.row].colorString {
            cell.backgroundColor = UIColor(hexString: colorCell)
        }

        
        return cell
    }

    // to do action on selcting/clicking the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categoryArray?[indexPath!.row]
    }
    
    //MARK: -  Data Methods
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error is\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
         categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
                        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                            do {
                                try self.realm.write( {
                                    self.realm.delete(categoryForDeletion)
                                })
                            }catch {
                                print(error)
                            }
                        }
                        
                       
    }
    
    
    //MARK: - Button Function

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create reference to the Field to hold the text from the closure
        var textField = UITextField()
        // to create iOS Popup
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorString = UIColor.randomFlat().hexValue()
           
            // to update UI
            self.save(category: newCategory)
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new Category"
            textField = alertTextField
        }
        // to embbed the action in the alert
        alert.addAction(action)
        
        // to show the alert
        present(alert, animated: true, completion: nil)
    }
    
   
    

}
