//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-02-01.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
       

    }
    //MARK: TABLE VIEW NUMBER OF ROWS
    //SETS UP NUMBER OF ROWS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK: CELL FOR ROW AT INDEX PATH
    //SECOND METHOD NEEDED TO LOAD DATA INTO THE CELLS.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"  //SETS CELL TO ITEM IN ARRAY
        //cell.accessoryType = item.done ? .checkmark : .none  //ADDS CHECK MARK OR OTHER ACCESSORY SPECIAL IF STATMENT HERE.
        //#################################################
        return cell
    }
    
    
    //MARK: - SAVE DATA
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
            
        }
        
    }
    
    //MARK: LOADING DATA
    func loadData() {
        categoryArray = realm.objects(Category.self)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItem", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //WHEN MAKING AN ALERT TO GRAB TEXT FIELD DATA SET A CONSTANT TO A INSTANCE OF UITEXTFIELD
        
        //This creates the alert
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        //this creates the action to do and executes once done pressed
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //CREATE AN INSTANCE TO ATTACH TO CORE DATA
            let newCategory = Category()
            newCategory.name = textField.text! //SETTING ENTERED TEXT FIELD TO INSTANCE PROPERTY
            //newCategory.done = false
            
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category to Add"
            textField = alertTextField  //SETTING VARIBLE TO BE USED OUTSIDE LOCAL SCOPE
            
            }
        
        alert.addAction(action)  //ADD THE ALERT TO THE ACTION
        present(alert, animated: true, completion: nil) //PRESENT THE ALERT
        
        
    }
    

}
