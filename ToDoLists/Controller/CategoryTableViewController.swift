//
//  CategoryTableViewController.swift
//  ToDoLists
//
//  Created by Jane Zhu on 3/8/19.
//  Copyright © 2019 JaneZhu. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    private var categoriesArray = [Category]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }

    private func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("error fetching categories: \(error)")
        }
        tableView.reloadData()
        title = "To Do Lists (\(categoriesArray.count))"
    }
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving category: \(error)")
        }
        tableView.reloadData()
        title = "To Do Lists (\(categoriesArray.count))"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Enter category"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let categoryName = alert.textFields!.first!.text else {
                return
            }
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName
            self.categoriesArray.append(newCategory)
            self.saveCategories()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoriesArray[indexPath.row]
        }
    }
}
