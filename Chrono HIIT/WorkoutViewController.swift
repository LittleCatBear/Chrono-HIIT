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


//global ManagedObjectContext for the whole app
var managedObjectContext: NSManagedObjectContext? = nil

//global workout object
var workoutModel:WorkoutModel = WorkoutModel()

//global array of exercises object
var exercises:[ExerciseModel] = [ExerciseModel]()

//global MAnagedObjectId for a selected previously saved workout (from Core Data)
var workoutId:NSManagedObjectID = NSManagedObjectID()

//when "new workout" (+) clicked on WorkoutViewController, token1 = true
var token1:Bool = false

//for TimerViewController field cleaning when a new workout had been selected
var token2:Bool = false

var isRegistered:Bool = false
var isUnregistered:Bool = false
var isNew:Bool = true


class WorkoutViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var workouts:[Workout] = [Workout]()
    var index = -1
    
    @IBOutlet weak var workoutTable: UITableView!
    @IBOutlet weak var topBarView: UIView!

    @IBOutlet weak var plusbutton: UIButton!
    
    @IBOutlet weak var newWorkoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        workoutTable.delegate = self
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDel.managedObjectContext!
        workoutModel.exercise = exercises
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
            error: &error) as! [Workout]?
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
            error: &error) as! [Workout]?
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
        return customWorkoutCellAtIndexPath(indexPath)
    }
    
    func customWorkoutCellAtIndexPath(indexPath: NSIndexPath) -> CustomWorkoutCell{
        var cell = self.workoutTable.dequeueReusableCellWithIdentifier("customWorkoutCell") as! CustomWorkoutCell
        if(workouts.count == 0){
            hideAll(cell, indexPath: indexPath)
        }else{
            if(String(workouts[indexPath.row].name) != nil){
                showAll(cell, indexPath: indexPath)
            }
        }
        return cell
    }
    
    func hideAll(cell: CustomWorkoutCell, indexPath: NSIndexPath){
        cell.titleLabel.hidden = true
        cell.titleLabel.sizeToFit()
        cell.totalTimeLabel.text = ""
        cell.nbExLabel.text = ""
        cell.startButton.hidden = true
        cell.startButton.enabled = false
        cell.toEditLabel.hidden = true
        cell.beginWorkoutLabel.hidden = true
        cell.noData.hidden = false
        cell.userInteractionEnabled = false
        tabBarController?.tabBar.tintColor = blue()
        blueDesign()
    }
    
    func showAll(cell: CustomWorkoutCell, indexPath: NSIndexPath){
        cell.titleLabel.text = workouts[indexPath.row].name
        cell.titleLabel.hidden = false
        cell.totalTimeLabel.text = "\(workouts[indexPath.row].totalTime)\""
        if(workouts[indexPath.row].exercise.count > 1){
            cell.nbExLabel.text = " \(String(workouts[indexPath.row].exercise.count)) exercises"
        } else{
            cell.nbExLabel.text = " \(String(workouts[indexPath.row].exercise.count)) exercise"
        }
        
        cell.startButton.hidden = false
        cell.startButton.enabled = true
        cell.toEditLabel.hidden = false
        cell.beginWorkoutLabel.hidden = false
        cell.userInteractionEnabled = true
        cell.noData.hidden = true
        cell.startButton.tag = indexPath.row
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        if(workouts.count > 0){
            generateWorkoutModel(indexPath.row)
            registerWorkout()
            isNew = false
            self.tabBarController?.tabBar.tintColor = red()
            tabBarController?.selectedIndex = 1
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if(workouts.count != 0){
                if(workouts[indexPath.row].objectID == workoutId){
                    unregisterWorkout()
                    newWorkout()
                    if let controllers = self.tabBarController?.viewControllers{
                        for vc in controllers{
                            if(vc is SecondViewController){
                                var cont = vc as! SecondViewController
                                cont.cleanFields()
                            } else if (vc is FirstViewController){
                                var cont = vc as! FirstViewController
                                cont.cleanData()
                                cont.exerciseTableView.reloadData()
                            }
                        }
                    }
                }
                managedObjectContext?.deleteObject(workouts[indexPath.row] as Workout)
                managedObjectContext?.save(nil)
                workouts.removeAtIndex(indexPath.row)
                if(workouts.count > 0){
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                } else{
                    tableView.reloadData()
                }
                unregisterWorkout()
                newWorkout()
                self.tabBarController?.tabBar.tintColor = blue()
                blueDesign()
            }
        }
    }
    
    func generateWorkoutModel(index: NSInteger){
        workoutId = workouts[index].objectID
        workoutModel.name = workouts[index].name
        workoutModel.swap = workouts[index].swap
        workoutModel.countdown = workouts[index].countdown
        workoutModel.totalTime = workouts[index].totalTime
        
        exercises.removeAll()
        for (var i = 0; i<workouts[index].exercise.count ; i++){
            let ex = ExerciseModel()
            ex.name = workouts[index].exercise[i].name
            exercises.append(ex)
        }
        workoutModel.exercise = exercises
    }

    @IBAction func onClickAddWorkoutButton(sender: UIButton) {
        unregisterWorkout()
        newWorkout()
        self.tabBarController?.tabBar.tintColor = blue()
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func onClickStartButton(sender: UIButton) {
        performSegueWithIdentifier("showTimerFromSavedWorkout", sender: sender)
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        var button = sender as! UIButton
        
        generateWorkoutModel(button.tag)
        registerWorkout()
    }
    
    func registerWorkout(){
        isRegistered = true
        isUnregistered = false
        isNew = false
    }
    
    func unregisterWorkout(){
        isRegistered = false
        isUnregistered = true
    }
    
    func newWorkout(){
        isNew = true
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