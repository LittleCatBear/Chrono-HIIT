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
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
   
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    //# MARK: prepare and load view, with tableview cleaning and loading if needed
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //   findFontNames()
        ExerciseTextField.delegate = self
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tap.cancelsTouchesInView = false
        self.exerciseTableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (isNew){
            cleanData()
            workoutStatusLabel.text = "New workout"
            hideUpdateButton()
            blueDesign()
            self.exerciseTableView.reloadData()
            
        }
        else if (isUnregistered){
            workoutStatusLabel.text = "New workout"
            hideUpdateButton()
            blueDesign()
        }else{
            self.exerciseTableView.reloadData()
            workoutStatusLabel.text = "Workout \(workoutModel.name)"
            showUpdateButton()
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
        ExerciseTextField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# MARK: snippet to find every available fonts
    func findFontNames(){
        for familyName in UIFont.familyNames(){
            NSLog("\(familyName)")
            for fontName in UIFont.fontNamesForFamilyName(String(format: (familyName as! NSString) as String)) {
                NSLog("    \(fontName)");
            }
        }
    }
    
    //# MARK: add a new exercise in tableview and temporary exercises array of a workout
    @IBAction func onClickAddExercise(sender: UIButton) {
        addExercise()
    }
    
    func addExercise(){
        if (self.ExerciseTextField.text != ""){
            var ex = ExerciseModel()
            ex.name = self.ExerciseTextField.text
            exercises.append(ex)
            updateExercisesList()
            self.ExerciseTextField.text = ""
            self.exerciseTableView.reloadData()
            if(isNew){
                isUnregistered = true
            }
            
        }
    }
    
    func updateExercisesList(){
        workoutModel.exercise =  exercises
    }
    
    //# MARK: exercises tableview management
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return customExerciseCellAtIndexPath(indexPath)
    }
    
    func customExerciseCellAtIndexPath(indexPath: NSIndexPath) -> CustomExerciseCell{
        var cell = self.exerciseTableView.dequeueReusableCellWithIdentifier("customExerciseCell") as! CustomExerciseCell
        cell.exerciseCellLabel.text = exercises[indexPath.row].name
        cell.exerciseCellLabel.textColor = UIColor.blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //colour
       
        var selectedCell:CustomExerciseCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomExerciseCell
        if(isRegistered){
            selectedCell.contentView.backgroundColor = red()
        }
        else{
            selectedCell.contentView.backgroundColor = blue()
        }
        selectedCell.exerciseCellLabel.textColor = UIColor.whiteColor()
        
        //speech
        var say = exercises[indexPath.row].name
        speech(say)
        
    }
   
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var deselectedCell:CustomExerciseCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomExerciseCell
        deselectedCell.exerciseCellLabel.textColor = UIColor.blackColor()
    }
    
    func speech(say:String){
        myUtterance = AVSpeechUtterance(string:say)
        myUtterance.rate = 0.1
        synth.speakUtterance(myUtterance)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            exercises.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            updateExercisesList()
        }
    }
    
    //# MARK: update workout
    
    @IBAction func onClickUpdateButton(sender: UIButton) {
        
        if(validateData()){
            if(workoutModel.name != " "){
                updateWorkout()
            } else{
                    var alert = UIAlertController(title: "Updating your workout", message: "Please enter a name for your workout: ", preferredStyle: UIAlertControllerStyle.Alert)
                    var name = ""
                    
                    alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                        textField.placeholder = "Enter workout name:"
                        
                    })
                    var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    }
                    alert.addAction(cancelAction)
                
                    alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        let textField = alert.textFields![0] as! UITextField
                        name = textField.text
                        if name != ""{
                            workoutModel.name = name
                            self.updateWorkout()
                        } else{
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //Get the Core Data Workout to update by its ManagedObjectID got from WorkoutViewController (when a cell is selected)
    func getWorkoutToUpdatewithId()->Workout{
        var toUpdate:Workout = managedObjectContext?.objectWithID(workoutId) as! Workout
        return toUpdate
    }
    
    // updating a workout: delete odl exercises array and create a new one with current exercise array from FirstViewController
    func updateWorkout(){
        var toUpdate = getWorkoutToUpdatewithId()
        
        let fetchRequest = NSFetchRequest(entityName:"Exercise")
        let predicate = NSPredicate(format: "workout == %@", toUpdate)
        fetchRequest.predicate = predicate
        
        var err: NSError? = nil
        var exeToDelete = managedObjectContext!.executeFetchRequest(fetchRequest,error: &err)! as! [Exercise]
        for e in exeToDelete{
            //    NSLog("deletion: %@", e)
            managedObjectContext!.deleteObject(e as Exercise)
        }
        
        toUpdate.setValue(workoutModel.name, forKey: "name")
        toUpdate.setValue(workoutModel.countdown, forKey: "countdown")
        toUpdate.setValue(workoutModel.totalTime, forKey: "totalTime")
        toUpdate.setValue(workoutModel.swap, forKey: "swap")
        
        var exe:[Exercise] = [Exercise]()
        for e in workoutModel.exercise{
            let ent = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: managedObjectContext!)
            let ex = NSManagedObject(entity: ent!, insertIntoManagedObjectContext:managedObjectContext) as! Exercise
            ex.setValue(e.name, forKey: "name")
            exe.append(ex)
        }
        
        toUpdate.setValue(NSOrderedSet(array: exe), forKey: "exercise")
        
        var error: NSError?
        if !(managedObjectContext?.save(&error) != nil) {
            println("Could not save workout\(error), \(error?.userInfo)")
            self.view.makeToast(message: "An error occured, your workout is not updated", type:"ko")
        }
        else{
            self.view.makeToast(message: "Workout updated!", type:"ok")
        }
        managedObjectContext?.reset()
    }

    
    
    func validateData() -> Bool {
        var flag:Bool = false
        
        if(exercises.count > 0){
            
            if (NSInteger(workoutModel.swap) > 0){
                if(NSInteger(workoutModel.totalTime) > 0){
                    if(NSInteger(workoutModel.countdown) >= 0){
                        if(workoutModel.name != ""){
                            flag = true
                        }else{
                            self.view.makeToast(message: "Workout name shouldn't be empty", duration:3.0, title: "Invalid data", type:"ko")
                        }
                    }else{
                        self.view.makeToast(message: "Countdown should be >= 0 sec ", duration:3.0, title: "Invalid data", type:"ko")
                    }
                } else{
                    self.view.makeToast(message: "Total time should be >= 1 sec", duration:3.0, title: "Invalid data", type:"ko")
                }
            } else{
                self.view.makeToast(message: "Swap timing should be >= 1 sec", duration:3.0, title: "Invalid data", type:"ko")
            }
        }else{
            self.view.makeToast(message: "You should at least have 1 exercise in your workout ", duration:3.0, title: "Invalid data", type:"ko")
        }
        return flag
    }

    
    //# MARK: keyboard behaviour
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        addExercise()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func hideKeyboard(){
        
       self.view.endEditing(false)
    }
    
    
    //# MARK: Label design (color)
    func redDesign(){
        topBarView.backgroundColor = red()
        addExerciseLabel.textColor = red()
        exercisesLabel.textColor = red()
        addLabel.textColor = red()
        updateLabel.textColor = red()
        plusButton.setImage(UIImage(named: "plusRed.png"), forState: UIControlState.Normal)
        
        
    }
    
    func blueDesign(){
        topBarView.backgroundColor = blue()
        addExerciseLabel.textColor = blue()
        addLabel.textColor = blue()
        exercisesLabel.textColor = blue()
        plusButton.setImage(UIImage(named: "plusBlue.png"), forState: UIControlState.Normal)
        
    }
    
    func red() -> UIColor{
        return UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
    }
    
    func blue() -> UIColor{
        return UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }
    
    func hideUpdateButton(){
        updateButton.enabled = false
        updateButton.hidden = true
        updateLabel.hidden = true
    }
    func showUpdateButton(){
        updateButton.enabled = true
        updateButton.hidden = false
        updateLabel.hidden = false
    }
}

