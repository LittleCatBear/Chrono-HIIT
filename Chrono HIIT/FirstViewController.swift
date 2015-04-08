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

var isRegistered:Bool = false
var isUnregistered:Bool = false
var isNew:Bool = true

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
  
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    //# MARK: prepare and load view, with tableview cleaning and loading if needed
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDel.managedObjectContext!
        workoutModel.exercise = exercises
     //   findFontNames()
        ExerciseTextField.delegate = self
      //  self.exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (isUnregistered){
            workoutStatusLabel.text = "New workout"
            blueDesign()
            //rself.exerciseTableView.reloadData()
        }
        else if (!isRegistered){
            cleanData()
            workoutStatusLabel.text = "New workout"
            blueDesign()
            self.exerciseTableView.reloadData()
        }else{
            self.exerciseTableView.reloadData()
            workoutStatusLabel.text = "Workout \(workoutModel.name)"
            redDesign()
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
            isNew = false
            isUnregistered = true
        }
    }
    
    //# MARK: exercises tableview management
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return customExerciseCellAtIndexPath(indexPath)
    }
    
    func customExerciseCellAtIndexPath(indexPath: NSIndexPath) -> CustomExerciseCell{
    var cell = self.exerciseTableView.dequeueReusableCellWithIdentifier("customExerciseCell") as CustomExerciseCell
    cell.exerciseCellLabel.text = exercises[indexPath.row].name
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
    func redDesign(){
        topBarView.backgroundColor = red()
        addExerciseLabel.textColor = red()
        exercisesLabel.textColor = red()
        plusButton.setImage(UIImage(named: "plusRed.png"), forState: UIControlState.Normal)
        
    }
    
    func blueDesign(){
        topBarView.backgroundColor = blue()
        addExerciseLabel.textColor = blue()
        exercisesLabel.textColor = blue()
        plusButton.setImage(UIImage(named: "plusBlue.png"), forState: UIControlState.Normal)
        
    }
    
    func red() -> UIColor{
        return UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
    }
    
    func blue() -> UIColor{
        return UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }

}

