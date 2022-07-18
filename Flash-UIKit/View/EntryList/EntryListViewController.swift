//
//  ViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/6/26.
//

import UIKit
import CoreData

class EntryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    var path = NSHomeDirectory()
    let data = ["one", "two", "three"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Entry]?
    
    private var tableView: UITableView = UITableView()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        setupNavigationBar()
        
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchEntries()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - ViewSetup
    
    func setupNavigationBar() {
        title = "Home"
        navigationItem.largeTitleDisplayMode = .always
        
        let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(EntryListViewController.editEntries))
        let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(EntryListViewController.addEntry))
        
        self.navigationItem.leftBarButtonItem = editButton
        self.navigationItem.rightBarButtonItem = addButton
    }

    
    func setupLayout() {
        
    }
    
    // MARK: - Private
    func fetchEntries() {
        do {
            self.items = try context.fetch(Entry.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Getting entries failed...")
        }
    }
    
    @objc func addEntry() {
        let alert = UIAlertController(title: "New note", message: "Adding a new note", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Save note", style: .default) { (action) in
            let textfield = alert.textFields![0]
            
            // Create a Entry object
            let newEntry = Entry(context: self.context)
            newEntry.id = UUID()
            newEntry.content = textfield.text
            newEntry.createdAt = Date()
            newEntry.updatedAt = newEntry.createdAt
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Save notes error...")
            }
            
            // Re-fetch the data
            self.fetchEntries()
        }
        
        // Add button
        alert.addAction(submitButton)
        
        // Showing alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editEntries() {
        
    }
    
    func handleData() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.items?.count else { return 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.identifier, for: indexPath) as! EntryTableViewCell
        
        var content: String = "Nothing"
        
        if let entry = self.items?[indexPath.row] {
            content = entry.content!
        }
        
        cell.contentLabel.text = content
        cell.createdAtLabel.text = "today"
        cell.repliesCountLabel.text = "0"
        return cell
    }
}