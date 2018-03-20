//
//  MovieTypeViewController.swift
//  MoviesListApp
//
//  Created by robin on 2018-03-14.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData

class MovieTypeViewController: UITableViewController {

    
    // this is your database variable - it lets you access and manipulate the CoreData db
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // data source --> array of Category objects
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // Actions
    @IBAction func addMovieCategory(_ sender: UIBarButtonItem) {
        
        
        let alertBox = UIAlertController(title: "Add Movie", message: "Enter the movie title", preferredStyle:.alert)
        
        alertBox.addTextField()
        
        let saveButton = UIAlertAction(title: "OK", style: .default, handler: {
            
            action in
            
            let name = alertBox.textFields?[0].text
            
            if name!.isEmpty == true {
                return
            }
            
            // create a new Category object
            let movieCategory = Category(context: self.myContext)
            
            // set the name of the category
            movieCategory.name = name!
            
            // add the Category to the categories array
            self.categories.append(movieCategory)
            
            // save the data and reload the table view
            self.saveData()
            
            self.tableView.reloadData()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertBox.addAction(saveButton)
        alertBox.addAction(cancelButton)
        
        present(alertBox, animated:true)
        
        
    }
    
    
    
    
    // TableView methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! ViewController
        
        let index = tableView.indexPathForSelectedRow
        if (index != nil) {
            dest.genre = categories[index!.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // show something in each row of the table
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTypeCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // total number of rows
        return categories.count
    }
    
    // delete on swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            
            // LOGIC: delete the movie from the context
            myContext.delete(categories[indexPath.row])
            saveData()
            
            // UI/LOGIC: delete the movie from the array
            self.categories.remove(at: indexPath.row)
            
            // UI:  delete the movie from the tableview
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    // Core Data methods
    func saveData() {
        do {
           try myContext.save()
        }
        catch {
            print("An error occured: \(error)")
        }
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try myContext.fetch(request)
        }
        catch {
           print("An error occured: \(error)")
        }
    }
    
    
    

}
