//
//  ViewController.swift
//  ToDoList
//
//  Created by Connor Boyce on 8/16/19.
//  Copyright © 2019 Connor Boyce. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoItems?.count ?? 1


    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }

        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                    print("Error updating the database \(error)")
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }


        
        

    
    //MARK - Add new Items
    
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button
            if let currentCategory = self.selectedCategory {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                self.save(item: newItem, category: currentCategory)
            }

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK - Model Manipulation Method
    
    func save(item : Item, category : Category) {
        
        do{
            try realm.write {
                category.items.append(item)
            }
        } catch {
            print("Error saving context \(error)")
        }
         tableView.reloadData()
        
    }
    func loadItems(){

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.toDoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                    print("Data successfully deleted")
                }
            } catch {
                print("Error deleting data \(error)")
            }
        }

    }
}

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}



