//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [ItemEntity]()
    //let defaults = UserDefaults.standard
    // create Database Contex
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : CategoryEntity? {
        didSet {
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to get path File where SQLite saved
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
    }
    
    // to get the number of needed cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    // to show the content of list on the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].titel
        
        // to avoid problem with reusable cells
        if itemArray[indexPath.row].isDone == false {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    // to do action on selcting/clicking the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle the checkmark as selected
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        //to delete an item
        // context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        saveItems()
        // to flash the gray background as user click it
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // to create iOS Popup
        let alert = UIAlertController(title: "Add a new Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = ItemEntity(context: self.context)
            newItem.titel = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            // save data like in Local Storage to avoid losing data when App terminated
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // to update UI
            self.saveItems()
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        // to embbed the action in the alert
        alert.addAction(action)
        
        // to show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error is\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest(), with predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionPredicate])
            
            request.predicate = compoundPredicate
        }else {
            request.predicate = categoryPredicate
        }
        
    
        do {
           itemArray =  try context.fetch(request)
        } catch  {
            print(error)
        }
        
        tableView.reloadData()
    }
}


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //create a request each time want to fetch from CoreData
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        // create query predicate to filter the datain CoreData
        let predicate = NSPredicate(format: "titel CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        // to put sort rule
        let sortDescriptor = NSSortDescriptor(key: "titel", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request,with: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // to dismiss keyboard and arrow cursor in searchBar after dleteing Text insdide of searchBar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

