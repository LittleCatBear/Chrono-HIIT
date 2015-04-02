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
        self.workoutTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getWorkouts()
        
    }
    
    func getWorkouts(){
        let fetchRequest = NSFetchRequest(entityName:"Workout")
        
        var error: NSError?
        
        let fetchedResults =
        managedObjectContext?.executeFetchRequest(fetchRequest,
            error: &error) as [Workout]?
        
        if let results = fetchedResults {
            workouts = results as [Workout]
            println(workouts[0].name)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.workoutTable.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        println(workouts[indexPath.row].name)
        cell.textLabel?.text = workouts[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        workout = workouts[indexPath.row]
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            workouts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

}