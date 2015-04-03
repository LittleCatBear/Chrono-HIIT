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
   
    var workouts:[Workout] = [Workout]()
    var index = -1
    
    @IBOutlet weak var workoutTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTable.delegate = self
        self.workoutTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellw")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getWorkouts()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.workoutTable.reloadData()
    }
    
    func getWorkouts(){
        let fetchRequest = NSFetchRequest(entityName:"Workout")
        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError?
        
        let fetchedResults =
        managedObjectContext?.executeFetchRequest(fetchRequest,
            error: &error) as [Workout]?
        if let results = fetchedResults {
            if(results.count>=1 && String(results[0].name) != nil){
                workouts = results as [Workout]
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func getWorkoutToUpdate(){
        let fetchRequest = NSFetchRequest(entityName:"Workout")
        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError?
        
        let fetchedResults =
        managedObjectContext?.executeFetchRequest(fetchRequest,
            error: &error) as [Workout]?
        if let results = fetchedResults {
            if(results.count>=1 && String(results[0].name) != nil){
                workouts = results as [Workout]
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workouts.count == 0) ? 1:workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.workoutTable.dequeueReusableCellWithIdentifier("cellw") as UITableViewCell
        if(workouts.count == 0){
            cell.textLabel?.text = "You don't have any saved workouts"
        }else{
            if(String(workouts[indexPath.row].name) != nil){
                cell.textLabel?.text = workouts[indexPath.row].name
            }
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        index = indexPath.row
        workoutId = workouts[indexPath.row].objectID
        workoutModel.name = workouts[indexPath.row].name
        workoutModel.swap = workouts[indexPath.row].swap
        workoutModel.countdown = workouts[indexPath.row].countdown
        workoutModel.totalTime = workouts[indexPath.row].totalTime
        exercises.removeAll()
        for (var i = 0; i<workouts[indexPath.row].exercise.count ; i++){
            let ex = ExerciseModel()
            ex.name = workouts[indexPath.row].exercise[i].name
            exercises.append(ex)
        }
        workoutModel.exercise = exercises
        tabBarController?.selectedIndex = 1
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if(workouts.count != 0){
                managedObjectContext?.deleteObject(workouts[indexPath.row] as NSManagedObject)
                managedObjectContext?.save(nil)
                workouts.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }

    @IBAction func onClickAddWorkoutButton(sender: UIButton) {
        token1 = true
        tabBarController?.selectedIndex = 0
    }
}