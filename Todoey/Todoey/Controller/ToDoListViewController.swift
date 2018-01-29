//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-01-28.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.name = "Kill Bill"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.name = "The Sword"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.name = "Die, Die, Die"
        itemArray.append(newItem3)
        
        
        
        
        if let items = UserDefaults.standard.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.name
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: TABLE VIEW DELEGATES
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        item.done = !item.done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //This creates the alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        //this creates the action to do and executes once done pressed
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.name = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
         alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter Item to Add"
               textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

