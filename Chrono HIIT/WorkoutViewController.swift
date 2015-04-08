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
    @IBOutlet weak var topBarView: UIView!

    @IBOutlet weak var plusbutton: UIButton!
    
    @IBOutlet weak var newWorkoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //   println(isRegistered)
        workoutTable.delegate = self
        self.workoutTable.rowHeight = 82.0
      //  self.workoutTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customWorkoutCell")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        if(isRegistered){
            redDesign()
        } else{
            blueDesign()
        }
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
        /*
        var cell:CustomWorkoutCell = self.workoutTable.dequeueReusableCellWithIdentifier("customWorkoutCell") as CustomWorkoutCell
        if(workouts.count == 0){
            cell.titleLabel.text = "You don't have any saved workouts"
            cell.totalTimeLabel.text = ""
            cell.nbExLabel.text = ""
            cell.startButton.hidden = true
            cell.startButton.enabled = false
            //cell.textLabel?.text = "You don't have any saved workouts"
            //reset fields in others tabs
            
        }else{
            if(String(workouts[indexPath.row].name) != nil){
                cell.titleLabel.text = workouts[indexPath.row].name
                cell.totalTimeLabel.text = String(workouts[indexPath.row].totalTime)
                cell.nbExLabel.text = String(workouts[indexPath.row].exercise.count)
                cell.startButton.hidden = false
                cell.startButton.enabled = true
                //cell.textLabel?.text = workouts[indexPath.row].name
            }
        }
        */
        return customWorkoutCellAtIndexPath(indexPath)
    }
    
    func customWorkoutCellAtIndexPath(indexPath: NSIndexPath) -> CustomWorkoutCell{
        var cell = self.workoutTable.dequeueReusableCellWithIdentifier("customWorkoutCell") as CustomWorkoutCell
        if(workouts.count == 0){
            cell.titleLabel.text = "You don't have any saved workouts"
            cell.totalTimeLabel.text = ""
            cell.nbExLabel.text = ""
            cell.startButton.hidden = true
            cell.startButton.enabled = false
            //cell.textLabel?.text = "You don't have any saved workouts"
            //reset fields in others tabs
            
        }else{
            if(String(workouts[indexPath.row].name) != nil){
                cell.titleLabel.text = workouts[indexPath.row].name
                cell.totalTimeLabel.text = "\(String(workouts[indexPath.row].totalTime))' workout"
                cell.nbExLabel.text = " \(String(workouts[indexPath.row].exercise.count)) exercises"
                cell.startButton.hidden = false
                cell.startButton.enabled = true
                cell.startButton.tag = indexPath.row
                //cell.textLabel?.text = workouts[indexPath.row].name
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        if(workouts.count > 0){
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
            isRegistered = true
            isUnregistered = false
            self.tabBarController?.tabBar.tintColor = red()
            tabBarController?.selectedIndex = 1
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if(workouts.count != 0){
                managedObjectContext?.deleteObject(workouts[indexPath.row] as Workout)
                managedObjectContext?.save(nil)
                workouts.removeAtIndex(indexPath.row)
                if(workouts.count > 0){
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                } else{
                    tableView.reloadData()
                 //   tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                   // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                   // tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text = "You don't have any saved workouts"
                    
                   // tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                token1 = true
                token2 = true
                isRegistered = false
                isUnregistered = true
                self.tabBarController?.tabBar.tintColor = blue()
            }
        }
    }

    @IBAction func onClickAddWorkoutButton(sender: UIButton) {
        token1 = true
        isRegistered = false
        isUnregistered = true
        self.tabBarController?.tabBar.tintColor = blue()
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func onClickStartButton(sender: UIButton) {
        performSegueWithIdentifier("showTimerFromSavedWorkout", sender: sender)
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        var button = sender as UIButton
        workoutId = workouts[button.tag].objectID
        workoutModel.name = workouts[button.tag].name
        workoutModel.swap = workouts[button.tag].swap
        workoutModel.countdown = workouts[button.tag].countdown
        workoutModel.totalTime = workouts[button.tag].totalTime
        
        exercises.removeAll()
        for (var i = 0; i<workouts[button.tag].exercise.count ; i++){
            let ex = ExerciseModel()
            ex.name = workouts[button.tag].exercise[i].name
            exercises.append(ex)
        }
        workoutModel.exercise = exercises
        isRegistered = true
        isUnregistered = false

        //self.tableView(self.workoutTable, didSelectRowAtIndexPath: workoutTable.indexPathForSelectedRow()!)
    }
    
    //# MARK: design
    
    func blueDesign(){
        topBarView.backgroundColor = blue()
        newWorkoutLabel.textColor = blue()
        plusbutton.setImage(UIImage(named: "plusBlue.png"), forState: UIControlState.Normal)
    }
    
    func redDesign(){
        topBarView.backgroundColor = red()
        newWorkoutLabel.textColor = red()
        plusbutton.setImage(UIImage(named: "plusRed.png"), forState: UIControlState.Normal)
    }
    
    func red() -> UIColor{
        return UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
    }
    
    func blue() -> UIColor{
        return UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }
}