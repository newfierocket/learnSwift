//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Hynes on 2018-01-28.
//  Copyright © 2018 Christopher Hynes. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    

    
    
    var itemArray = [Item]()
    //CREATE PATH TO CUSTOM PLIST TO HANDLE DATA STORAGE
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        
    }
    
    
    //MARK: NUMBER OF ROWS IN SECTION
    //IMPORTANT FUNCTION FOR SETTING NUMBER OF ROWS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: SECOND METHOD NEEDED TO LOAD DATA INTO THE CELLS.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title //SETS CELL TO ITEM IN ARRAY
        cell.accessoryType = item.done ? .checkmark : .none  //ADDS CHECK MARK OR OTHER ACCESSORY SPECIAL IF STATMENT HERE.
        //#################################################
        return cell
    }
    
    //MARK: TABLE VIEW DELEGATES
    //DELEGATE METHOD WHEN A ROW IS SELECTED.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]  //SETTING ITEM TO ITEM ARRAY TO SAVE TYPING
        
        item.done = !item.done
        saveData()
        
        tableView.reloadData()   //HOW TO RELOAD TABLE VIEWS. DONT FORGET THIS
        
        tableView.deselectRow(at: indexPath, animated: true) //ADD THIS IN TO MAKE IT PRETTIER
    }
    
    //MARK: ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField() //WHEN MAKING AN ALERT TO GRAB TEXT FIELD DATA SET A CONSTANT TO A INSTANCE OF UITEXTFIELD
        
        //This creates the alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
       
        //this creates the action to do and executes once done pressed
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            //CREATE AN INSTANCE TO ATTACH TO CORE DATA
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //SETTING ENTERED TEXT FIELD TO INSTANCE PROPERTY
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveData()
            self.tableView.reloadData()
        }
        //LOADS TEXR FIELD IN ALERT BUT SEE NOTES ABOVE ABOUT GETTING TEXT FIELD DATA OUT FROM INSIDE CLOSURE
         alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter Item to Add"
                textField = alertTextField  //SETTING VARIBLE TO BE USED OUTSIDE LOCAL SCOPE
            
            
        }
        
        alert.addAction(action)  //ADD THE ALERT TO THE ACTION
        present(alert, animated: true, completion: nil) //PRESENT THE ALERT
    }
    
    
    //MARK: SAVING AND DECODING DATA.
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
            
        }
        
     
    }
    //MARK: LOADING DATA
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        
        }
            
        do {
            try itemArray = context.fetch(request)
        } catch {
            print("There was an error \(error)")
        }
        tableView.reloadData()
    }
      
}


//MARK: SEARCH BAR DELEGATE METHODES
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {  //used to hand back to main thread
            searchBar.resignFirstResponder()  //reliquinsh its response and gets rid of cursor and keyboard.

            }
        
    }
    }
    
    
}
























