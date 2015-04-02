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

var managedObjectContext: NSManagedObjectContext? = nil
//var workout = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: managedObjectContext!) as Workout
var workoutModel:WorkoutModel = WorkoutModel()
var exercises:[ExerciseModel] = [ExerciseModel]()

//when new workout clicked, token = true
var token1:Bool = false
//for timer controller ràz
var token2:Bool = false

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var ExerciseTextField: UITextField!
    
    
    //var exercises:[ExerciseModel] = [ExerciseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDel.managedObjectContext!
        workoutModel.exercise = exercises
        //findFontNames()
        ExerciseTextField.delegate = self
        
         self.exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if token1{
            println("data")
            cleanData()
            token1 = false
            token2 = true
            self.exerciseTableView.reloadData()
        }
        else if(!workoutModel.name.isEmpty){
            self.exerciseTableView.reloadData()
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
    
    func findFontNames(){
        for familyName in UIFont.familyNames(){
            for fontName in UIFont.fontNamesForFamilyName(String(format: familyName as NSString)) {
                NSLog("\(fontName)");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.exerciseTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = exercises[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            exercises.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    

}

