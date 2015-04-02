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

//var globalExerciceTable:[String] = [String]()


var managedObjectContext: NSManagedObjectContext? = nil
var workout = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: managedObjectContext!) as Workout

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var ExerciseTextField: UITextField!
    
    
    var exercises:[Exercise] = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDel.managedObjectContext!
        workout.exercise = NSOrderedSet(array: exercises)
        findFontNames()
        ExerciseTextField.delegate = self
        
         self.exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
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
            var ex = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: managedObjectContext!) as Exercise
            ex.name = self.ExerciseTextField.text
            exercises.append(ex)
            workout.exercise = NSOrderedSet(array: exercises)
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

