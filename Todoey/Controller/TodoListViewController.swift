//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to get path File where SQLite saved
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
        
        
       
    }
    
    // to get the number of needed cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    // to show the content of list on the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title
        
        
        // to avoid problem with reusable cells
        if todoItems?[indexPath.row].isDone == false {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    // to do action on selcting/clicking the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle the checkmark as selected
    //    todoItems?[indexPath.row].isDone = !todoItems?[indexPath.row].isDone
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                item.isDone = !item.isDone
            })
            } catch  {
                print(error)
            }
           
        }
        
        tableView.reloadData()
        
        // to flash the gray background as user click it
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        //TODO: hier brecht App ab, weil es nicht normal Cell zu Swipe Cell umwandeln kann
        var textField = UITextField()
        // to create iOS Popup
        let alert = UIAlertController(title: "Add a new Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
         
            if let currentCategory = self.selectedCategory {
             
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createDate = Date()
                        currentCategory.items.append(newItem)
                    })
                }catch {
                    print("Error is\(error)")
                }
            }
            self.tableView.reloadData()
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
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
       if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch  {
                print(error)
            }
        }
    }
}


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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

