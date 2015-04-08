//
//  SecondViewController.swift
//  ParseSample
//
//  Created by Remi Santos on 05/04/15.
//  Copyright (c) 2015 Remi Santos. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var todos:[PFObject] = []
    @IBOutlet weak var tableView: UITableView!
    var addTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            self.navigationController?.tabBarController?.selectedIndex = 0
        } else {
            loadTodos()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTodos() {
        var query = PFQuery(className: "Todo")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.todos = objects as [PFObject]
                self.tableView.reloadData()
            }
        }
    }
    func createTodoWithText(text:String?) {
        if text == nil {
            return
        }
        
        var todo = PFObject(className: "Todo")
        todo["name"] = text
        todo["user"] = PFUser.currentUser()
        todo.saveInBackground()
        todos.append(todo)
        self.tableView.reloadData()
    }
    
    @IBAction func addTodo(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New todo", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Call dad..."
            self.addTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            self.createTodoWithText(self.addTextField?.text)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableView datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath) as UITableViewCell
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo["name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let todo = todos[indexPath.row]
            todo.deleteInBackground()
            todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            PFAnalytics.trackEvent("Delete")
        }
    }
    // MARK: UITableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

