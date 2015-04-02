//
//  WorkoutViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 02/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WorkoutViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var workoutTable: UITableView!
    var workouts:[Workout] = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTable.delegate = self
        self.workoutTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellw")
        getWorkouts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getWorkouts()
        self.workoutTable.reloadData()
    }
    
    func getWorkouts(){
        let fetchRequest = NSFetchRequest(entityName:"Workout")
        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError?
        
        let fetchedResults =
        managedObjectContext?.executeFetchRequest(fetchRequest,
            error: &error) as [Workout]?
        NSLog("%@", fetchedResults!)
        if let results = fetchedResults {
            if(results.count>1 && String(results[0].name) != nil){
                //println("test")
                workouts = results as [Workout]
            }
           //println(workouts[0].name)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        println(workouts.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workouts.count == 0) ? 1:workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.workoutTable.dequeueReusableCellWithIdentifier("cellw") as UITableViewCell
        println(workouts.count)
        if(workouts.count == 0){
            cell.textLabel?.text = "You don't have saved workouts"
        }else{
            println("configure")
            println(workouts[0].name)
            self.configureCell(cell, atIndexPath: indexPath)
        }
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = workouts[indexPath.row].name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        workout = workouts[indexPath.row]
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if(workouts.count != 0){
                workouts.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }

}