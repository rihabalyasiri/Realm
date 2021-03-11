//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rihab Al-yasiri on 04.03.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // saving all Categories here to update the UI and no need to fetch them from Database whenever I nned them
    var categoryArray = [CategoryEntity]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // to get path File where SQLite saved
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    // to show the content of list on the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell with dequeueReusableCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // show data on the cell and return it
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }

    // to do action on selcting/clicking the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
      //  saveItems()
        // to flash the gray background as user click it
       // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categoryArray[indexPath!.row]
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error is\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()) {
      
        do {
           categoryArray =  try context.fetch(request)
        } catch  {
            print(error)
        }
        
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create reference to the Field to hold the text from the closure
        var textField = UITextField()
        // to create iOS Popup
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = CategoryEntity(context: self.context)
            newCategory.name = textField.text!
           
            
            self.categoryArray.append(newCategory)
            // save data like in Local Storage to avoid losing data when App terminated
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // to update UI
            self.saveItems()
           
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
    
   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
