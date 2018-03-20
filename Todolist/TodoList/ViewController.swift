//
//  ViewController.swift
//  MoviesListApp
//
//  Created by robin on 2018-03-13.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // data source -> an array of Movie objects
    var movies = [Movie]()
    
    // object that stores the movie category -> this gets passed from the MovieTypeController (segue)
    var genre : Category?
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // include this if you want to see where ios is storing your SQL file
        let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)
        print(path)
        
        if (genre != nil) {
           loadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // Mandatory Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = movie.name
        cell.detailTextLabel?.text = String(movie.seen)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do stuff when person clicks on a row
        print("Person clicked on something")
        print(indexPath.row)
        
        let movie = movies[indexPath.row]
        
        if (movie.seen == true) {
            movie.seen = false
        }
        else {
            movie.seen = true
        }
        
        saveData()
        
    }
    
    
    // --- Functions to Add / Delete stuff ----- //
    
    
    // add a movie to the list
    @IBAction func addMovie(_ sender: Any) {
        
        let alertBox = UIAlertController(title: "Add Something", message: "Enter ur todo list", preferredStyle:.alert)
        
        alertBox.addTextField()
        
        let saveButton = UIAlertAction(title: "OK", style: .default, handler: {
            
            action in
            
            let name = alertBox.textFields?[0].text
            if name!.isEmpty == true {
                return
            }
            
            // create a new Movie Entity
            let movie = Movie(context: self.myContext)
            
            // set the name of the movie
            movie.name = name!
            movie.seen = false
            movie.category = self.genre!
            
            // add the movie to the array
            self.movies.append(movie)
            
            // save the data and reload the table view
            self.saveData()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertBox.addAction(saveButton)
        alertBox.addAction(cancelButton)
        
        present(alertBox, animated:true)
        
    }
    
    
    
    // enable deleting on swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            // LOGIC: delete the movie from the context
            myContext.delete(movies[indexPath.row])
            saveData()
            
            // UI/LOGIC: delete the movie from the array
            self.movies.remove(at: indexPath.row)
            
            // UI:  delete the movie from the tableview
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            
        }
    }

    
    
    
    // --- Core Data functions ----- //
    func loadData() {
        
        // search the database for all movies that match the category name
        
        let request : NSFetchRequest<Movie> = Movie.fetchRequest()
       
        let predicate = NSPredicate(format: "category.name MATCHES %@", genre!.name!)
        
        request.predicate = predicate
        
        do  {
            movies = try myContext.fetch(request)
        }
        catch {
            print("error: \(error)")
        }
        print(movies)
    }
    
    
    func saveData() {
        print("Saving data")
        do {
            // get context and try to save
            try myContext.save()
        }
        catch {
            print("error saving data: \(error)")
        }
        
        print("done saving data")
        tableView.reloadData()
    }
    
}

