//
//  FirstViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 26/03/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

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

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //tableView of exercises, saved or to be saved, depending on the current context
    @IBOutlet weak var exerciseTableView: UITableView!
    
    //text field for adding a new exercise in the current workout
    @IBOutlet weak var ExerciseTextField: UITextField!
    
    //tells the user what king of workout it is (saved, new..)
    @IBOutlet weak var workoutStatusLabel: UILabel!
    
    //# MARK: IBOutlet for design
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var addExerciseLabel: UILabel!
    @IBOutlet var exercisesLabel: UIView!
    @IBOutlet weak var plusButton: UIButton!
    
    //# MARK: prepare and load view, with tableview cleaning and loading if needed
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDel.managedObjectContext!
        workoutModel.exercise = exercises
        findFontNames()
        ExerciseTextField.delegate = self
        self.exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if token1{
            cleanData()
            token1 = false
            token2 = true
            workoutStatusLabel.text = "New workout"
            self.exerciseTableView.reloadData()
        }
        else if(workoutModel.name != ""){
            self.exerciseTableView.reloadData()
            workoutStatusLabel.text = "Editing workout \(workoutModel.name)"
        }
    }
    
    func cleanData(){
        exercises.removeAll()
        workoutModel.name = ""
        workoutModel.countdown = 0
        workoutModel.totalTime = 0
        workoutModel.swap = 0
        workoutModel.exercise = exercises
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# MARK: snippet to find every available fonts
    func findFontNames(){
        for familyName in UIFont.familyNames(){
            NSLog("\(familyName)")
            for fontName in UIFont.fontNamesForFamilyName(String(format: familyName as NSString)) {
                NSLog("    \(fontName)");
            }
        }
    }

    //# MARK: add a new exercise in tableview and temporary exercises array of a workout 
    @IBAction func onClickAddExercise(sender: UIButton) {
        if (self.ExerciseTextField.text != ""){
           // var ex = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: managedObjectContext!) as Exercise
            var ex = ExerciseModel()
            ex.name = self.ExerciseTextField.text
            exercises.append(ex)
            workoutModel.exercise =  exercises
           // globalExerciceTable.append(self.ExerciseTextField.text)
            self.ExerciseTextField.text = ""
            self.exerciseTableView.reloadData()
        }
    }
    
    //# MARK: exercises tableview management
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.exerciseTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = exercises[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            exercises.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    //# MARK: keyboard behaviour
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    //# MARK: Label design (color)
    func blueDesign(){
        
    }
}

